//  Copyright

import Foundation
import FirebaseFirestore

protocol ChatStreaming {
    var currentPageSize: Int { get }

    var delegate: StreamDelegate? { get set }

    func startListeningRecentMessages(
        chatRoomId: String,
        channelId: String,
        perPage: Int
    )

    func loadPreviousMessages(
        chatRoomId: String,
        channelId: String,
        perPage: Int
    )

    func startListeningReactions()
}

class ChatStream: ChatStreaming {

    struct Constants {
        static let chatRooms: String = "chat-rooms"
        static let channels: String = "channels"
        static let messages: String = "messages"

        static let createdAt: String = "createdAt"
    }

    private let firestore: Firestore
    weak var delegate: StreamDelegate?
    private var firestoreListener: ListenerRegistration?
    private var userReactionsListener: ListenerRegistration?
    private(set) var currentPageSize: Int = 0

    init() throws {
        guard let firestore = ArenaChat.shared.firestore else {
            throw ProviderError.firebaseNotConfigured
        }
        self.firestore = firestore
    }

    deinit {
        firestoreListener?.remove()
        userReactionsListener?.remove()
    }

    func startListeningRecentMessages(
        chatRoomId: String,
        channelId: String,
        perPage: Int
    ) {
        firestoreListener?.remove()
        currentPageSize = perPage
        var firstEvent = true
        firestoreListener = firestore
            .collection(Constants.chatRooms)
            .document(chatRoomId)
            .collection(Constants.channels)
            .document(channelId)
            .collection(Constants.messages)
            .order(by: Constants.createdAt, descending: true)
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

    func loadPreviousMessages(
        chatRoomId: String,
        channelId: String,
        perPage: Int
    ) {
        currentPageSize += perPage
        startListeningRecentMessages(
            chatRoomId: chatRoomId,
            channelId: channelId,
            perPage: currentPageSize + 1
        )
    }

    func startListeningReactions() {
//        userReactionsListener?.remove()
//        let userId = ""
//        var firstEvent = true
//
//        userReactionsListener = firestore
//            .collection(Constants.reactions)
//            .whereField(Constants.userKey, isEqualTo: userId)
//            .whereField(Constants.eventKey, isEqualTo: streamData.eventId)
//            .addSnapshotListener { [weak self] (snapshot, error) in
//                guard let self = self else { return }
//                if let error = error {
//                    self.handleSnapshotError(error)
//                } else if let snapshot = snapshot {
//                    self.handleSnapshotSuccess(snapshot,
//                                               type: .reaction,
//                                               isReloading: firstEvent)
//                    firstEvent = false
//                }
//        }
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
