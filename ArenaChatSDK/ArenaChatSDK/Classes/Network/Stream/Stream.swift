//  Copyright

import Foundation
import FirebaseFirestore

protocol Streaming {
    var currentPageSize: Int { get }

    var delegate: StreamDelegate? { get set }

    func startListeningEvents()
    func requestNextEvents()
    func startListeningReactions()
}

class Stream: Streaming {

    struct Constants {
        static let events: String = "events"
        static let reactions: String = "reactions"

        static let priorityKey: String = "priority"
        static let createdAtKey: String = "createdAt"
        static let eventKey: String = "eventId"
        static let userKey: String = "userId"
    }

    private let firestore: Firestore
    private let streamData: StreamDatable
    weak var delegate: StreamDelegate?
    private var firestoreListener: ListenerRegistration?
    private var userReactionsListener: ListenerRegistration?
    private(set) var currentPageSize: Int

    init(streamData: StreamDatable) throws {
        guard let firestore = ArenaChat.shared.firestore else {
            throw ProviderError.firebaseNotConfigured
        }
        self.firestore = firestore
        self.streamData = streamData
        self.currentPageSize = streamData.pagination
    }

    deinit {
        firestoreListener?.remove()
        userReactionsListener?.remove()
    }

    func startListeningEvents() {
        firestoreListener?.remove()

        var firstEvent = true
        firestoreListener = firestore
            .collection(Constants.events)
            .document(streamData.eventId)
            .collection(streamData.collection)
            .order(by: Constants.priorityKey, descending: true)
            .order(by: Constants.createdAtKey, descending: streamData.descending)
            .limit(to: currentPageSize)
            .addSnapshotListener { [weak self] (snapshot, error) in
                guard let self = self else { return }
                if let error = error {
                    self.handleSnapshotError(error)
                } else if let snapshot = snapshot {
                    self.handleSnapshotSuccess(snapshot,
                                               type: .event,
                                               isReloading: firstEvent)
                    firstEvent = false
                }
        }
    }

    func requestNextEvents() {
        currentPageSize += streamData.pagination
        startListeningEvents()
    }

    func startListeningReactions() {
        userReactionsListener?.remove()
        let userId = ""
        var firstEvent = true

        userReactionsListener = firestore
            .collection(Constants.reactions)
            .whereField(Constants.userKey, isEqualTo: userId)
            .whereField(Constants.eventKey, isEqualTo: streamData.eventId)
            .addSnapshotListener { [weak self] (snapshot, error) in
                guard let self = self else { return }
                if let error = error {
                    self.handleSnapshotError(error)
                } else if let snapshot = snapshot {
                    self.handleSnapshotSuccess(snapshot,
                                               type: .reaction,
                                               isReloading: firstEvent)
                    firstEvent = false
                }
        }
    }

    private func handleSnapshotSuccess(_ snapshot: QuerySnapshot,
                                       type: SnapsnotType,
                                       isReloading: Bool) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            self.delegate?.stream(self,
                                  didReceivedSnapshot: snapshot,
                                  snapshotType: type,
                                  isReloading: isReloading)
        }
    }

    private func handleSnapshotError(_ error: Error) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            self.delegate?.stream(self, didReceivedError: error)
        }
    }
}
