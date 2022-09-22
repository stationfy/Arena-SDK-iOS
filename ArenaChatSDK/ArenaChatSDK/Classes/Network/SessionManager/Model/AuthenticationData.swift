import Foundation

public struct AuthenticationData: Codable {
    public let accessToken: String
    public let user: LoggedUser

    public init(accessToken: String, user: LoggedUser) {
        self.accessToken = accessToken
        self.user = user
    }
}

public struct LoggedUser: Codable, Equatable {
    public static func == (lhs: LoggedUser, rhs: LoggedUser) -> Bool {
        lhs._id == rhs._id &&
        lhs.name == rhs.name &&
        lhs.userName == rhs.userName &&
        lhs.provider == rhs.provider &&
        lhs.providerUserId == rhs.providerUserId &&
        lhs.email == rhs.email
    }

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
    let metaData: [String: String]?
    let isModerator: Bool?
    let isBanned: Bool?
}
