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
    let alreadyFavorited: Bool?
    let totalReactions: Int?

    init(createdAt: Double? = nil,
         key: String? = nil,
         content: MessageContent? = nil,
         publisherId: String? = nil,
         referer: String? = nil,
         replyMessage: Message? = nil,
         sender: MessageSender? = nil,
         type: String? = nil,
         changeType: String? = nil,
         reactions: [String: Int]? = nil,
         alreadyFavorited: Bool = false,
         totalReactions: Int? = nil) {
        self.createdAt = createdAt
        self.key = key
        self.content = content
        self.publisherId = publisherId
        self.referer = referer
        self.replyMessage = replyMessage
        self.sender = sender
        self.type = type
        self.changeType = changeType
        self.reactions = reactions
        self.alreadyFavorited = alreadyFavorited
        self.totalReactions = totalReactions
    }

    enum CodingKeys: String, CodingKey {
        case createdAt
        case key
        case content = "message"
        case publisherId
        case referer
        case replyMessage
        case sender
        case type
        case changeType
        case reactions
        case alreadyFavorited
        case totalReactions
    }
}
