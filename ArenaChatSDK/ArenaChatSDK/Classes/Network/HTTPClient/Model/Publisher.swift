import Foundation

struct Publisher: Decodable {
    let id: String
    let slug: String?
    let image: String?
    let websiteUrl: String?
    let uid: String?
    let displayName: String?
    let photoURL: String?

    let config: PublisherConfig?
    let featureFlags: [String: PublisherFeatureFlag]?

    let blocked: Bool?
    let deleted: Bool?
    let firebase: Bool?

    let settings: Settings?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case slug
        case image
        case config
        case websiteUrl
        case uid
        case displayName
        case photoURL
        case blocked
        case deleted
        case firebase
        case featureFlags
        case settings
    }
}
