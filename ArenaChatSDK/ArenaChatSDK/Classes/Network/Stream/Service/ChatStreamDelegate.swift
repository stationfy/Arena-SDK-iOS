import Foundation

protocol ChatStreamDelegate: class {
    func stream(_ stream: ChatStreamProvider,
                didReceivedMessages messages: [MessageResponse],
                isReloading: Bool)

    func stream(_ stream: ChatStreamProvider,
                didReceivedError error: Error)
}
