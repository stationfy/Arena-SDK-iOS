import Foundation

class Message: Decodable {
    let createdAt: Double?
    let key: String?
    let content: MessageContent?
    let publisherId: String?
    let referer: String?
    let replyMessage: Message?
    let sender: MessageSender?
    let type: String?
    let changeType: String?
    let reactions: [String: Int]?
    let alreadyFavorited: Bool
    let totalReactions: Int?

}
