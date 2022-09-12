import Foundation

struct LoggedUser: Decodable {
    let _id: String?
    let name: String?
    let userName: String?
    let urlName: String?
    let provider: String?
    let providerUserId: String?
    let profile: Profile?
    let image: String?
    let email: String?
    let token: String?
    let roles: [String]?
    let thumbnails: UserThumbnail?
    let joinedAt: String?
    let type: String?
    let metaData: [String: String]
    let isModerator: Bool?
    let isBanned: Bool?
}
