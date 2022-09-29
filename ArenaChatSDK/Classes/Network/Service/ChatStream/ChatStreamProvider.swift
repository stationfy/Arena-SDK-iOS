//  Copyright

import Foundation
import FirebaseFirestore

protocol ChatStreamProviding {

    var delegate: ChatStreamDelegate? { get set }

    func startListeningRecentMessages(
        chatRoomId: String,
        channelId: String
    )

    func loadPreviousMessages(
        chatRoomId: String,
        channelId: String
    )

    func stopListeners()
}

final class ChatStreamProvider: ChatStreamProviding {

    private var stream: ChatStreaming

    var currentPageSize: Int {
        stream.currentPageSize
    }

    private var lasIndex: UInt = 0
    var isLastPage: Bool = false

    weak var delegate: ChatStreamDelegate?

    init() throws {
        self.stream = try ChatStream()
        self.stream.delegate = self
    }

    func startListeningRecentMessages(
        chatRoomId: String,
        channelId: String
    ) {
        stream.startListeningRecentMessages(chatRoomId: chatRoomId,
                                            channelId: channelId,
                                            perPage: 20)
    }

    func loadPreviousMessages(
        chatRoomId: String,
        channelId: String
    ) {
        stream.loadPreviousMessages(chatRoomId: chatRoomId,
                                    channelId: channelId,
                                    perPage: 20)
    }

    private func handleEventSnapshot(_ query: QuerySnapshot, isReloading: Bool) {
        var messageResponses: [MessageResponse] = [MessageResponse]()

        isLastPage = lasIndex == query.documentChanges.last?.newIndex
        lasIndex = query.documentChanges.last?.newIndex ?? 0
        
        query.documentChanges.forEach { doc in
            do {
                let dataResponse = try doc.document.data().toData()
                let message: Message = try dataResponse.parse()

                switch doc.type {
                case .added:
                    messageResponses.append(MessageResponse(message: message,
                                                            action: .added(index: doc.newIndex)))
                case .modified:
                    messageResponses.append(MessageResponse(message: message,
                                                            action: .modified(from: doc.oldIndex, to: doc.newIndex)))
                case .removed:
                    messageResponses.append(MessageResponse(message: message,
                                                            action: .removed(index: doc.oldIndex)))
                }
            } catch let error {
                delegate?.stream(self, didReceivedError: error)
            }
        }

        delegate?.stream(self,
                         didReceivedMessages: messageResponses,
                         isReloading: isReloading)
    }

    func stopListeners() {
        stream.stopListeners()
    }
}

extension ChatStreamProvider: StreamDelegate {
    func stream(_ stream: ChatStreaming,
                didReceivedSnapshot snapshot: QuerySnapshot,
                snapshotType type: SnapsnotType,
                isReloading: Bool) {
        handleEventSnapshot(snapshot, isReloading: isReloading)
    }

    func stream(_ stream: ChatStreaming, didReceivedError error: Error) {
        // TODO: Error handling
        delegate?.stream(self, didReceivedError: error)
        print("did receive error \(error)")
    }
}
