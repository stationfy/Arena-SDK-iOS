import Foundation

struct MessageResponse {
    let message: Message
    let action: MessageResponseAction
}

enum MessageResponseAction {
    case added(index: UInt)
    case modified(from: UInt, to: UInt)
    case removed(index: UInt)
}
