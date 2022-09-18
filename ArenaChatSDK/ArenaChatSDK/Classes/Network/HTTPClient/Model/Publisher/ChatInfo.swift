import Foundation

struct ChatInfo: Decodable {

    let id: String?
    let profanityFilterType: String?
    let slug: String?
    let siteId: String?
    let name: String?
    let createdBy: String?
    let presenceId: String?

    let streams: [String]?

    let mainChannelId: String?
    let chatPreModerationIsEnabled: Bool?
    let chatClosedIsEnabled: Bool?
    let allowShareUrls: Bool?
    let signUpRequired: Bool?
    let standalone: Bool?
    let global: Bool?

    let updatedAt: Int64?
    let createdAt: Int64?

    let version: Int?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case version = "__v"
        case profanityFilterType
        case slug
        case siteId
        case name
        case createdBy
        case presenceId
        case streams
        case mainChannelId
        case chatPreModerationIsEnabled
        case chatClosedIsEnabled
        case allowShareUrls
        case signUpRequired
        case standalone
        case global
        case updatedAt
        case createdAt
    }
}
