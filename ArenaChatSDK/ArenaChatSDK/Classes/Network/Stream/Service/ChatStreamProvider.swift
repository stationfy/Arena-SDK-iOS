//  Copyright

import Foundation
import FirebaseFirestore

protocol ChatStreamProviding {

    var delegate: ChatStreamDelegate? { get set }

    func startListeningEvents()
    func requestNextEvents()
}

final class ChatStreamProvider: ChatStreamProviding {

    private var stream: Streaming

    var currentPageSize: Int {
        stream.currentPageSize
    }

    private var streamData: StreamDatable

    weak var delegate: ChatStreamDelegate?

    init(streamData: StreamDatable) throws {
        self.stream = try Stream(streamData: streamData)
        self.streamData = streamData
        self.stream.delegate = self
    }

    func startListeningEvents() {
        stream.startListeningEvents()
        stream.startListeningReactions()
    }

    func requestNextEvents() {
        stream.requestNextEvents()
    }

    private func handleEventSnapshot(_ query: QuerySnapshot, isReloading: Bool) {
        var messageResponses: [MessageResponse] = [MessageResponse]()

        query.documentChanges.forEach { doc in
            guard let dataResponse = try? doc.document.data().toData(),
                  let message: Message = try? dataResponse.parse() else { return }
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
        }

        delegate?.stream(self,
                         didReceivedMessages: messageResponses,
                         isReloading: isReloading)
    }
}

extension ChatStreamProvider: StreamDelegate {
    func stream(_ stream: Streaming,
                didReceivedSnapshot snapshot: QuerySnapshot,
                snapshotType type: SnapsnotType,
                isReloading: Bool) {
        handleEventSnapshot(snapshot, isReloading: isReloading)
    }

    func stream(_ stream: Streaming, didReceivedError error: Error) {
        // TODO: Error handling
        delegate?.stream(self, didReceivedError: error)
        print("did receive error \(error)")
    }
}
