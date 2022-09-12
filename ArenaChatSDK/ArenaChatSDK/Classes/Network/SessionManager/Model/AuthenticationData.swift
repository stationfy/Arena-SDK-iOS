import Foundation

public struct AuthenticationData: Codable {
    public let accessToken: String
    public let user: User

    public init(accessToken: String, user: User) {
        self.accessToken = accessToken
        self.user = user
    }
}

public struct User: Codable, Equatable {
    let userId: String?
    let isAnonymous: Bool
    let name: String?
    let country: String?
    let image: String?
    let isMobile: Bool
}
