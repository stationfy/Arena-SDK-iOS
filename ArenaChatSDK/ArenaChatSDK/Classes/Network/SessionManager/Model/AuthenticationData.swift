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
    public let id: Int
    public let email: String
    public let firstName: String
    public let lastName: String
}
