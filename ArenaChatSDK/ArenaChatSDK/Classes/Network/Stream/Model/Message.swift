import Foundation

class Message: Decodable {
    let createdAt: Decimal
    let key: String?
    let content: MessageContent?
    let publisherId: String?
    let referer: String
    let replyMessage: Message?
    let sender: MessageSender
    let type: String?
    let changeType: String?
    let messageType: MessageType
    let reactions: [String: Int]?
    let alreadyFavorited: Bool
    let totalReactions: Int?
}

enum MessageType: Int, Decodable {
    case sender = 4356
    case senderReply = 4352
    case date = 5623
    case pool = 5467
    case receivedReply = 3463
    case received = 7562
}
