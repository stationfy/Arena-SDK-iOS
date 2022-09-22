import Foundation

public struct ExternalUser: Codable {
    let id: String
    let name: String?
    let email: String?
    let image: String?
    let familyName: String?
    let givenName: String?
    let extras: [String: String]

    public init(id: String,
                name: String? = nil,
                email: String? = nil,
                image: String? = nil,
                familyName: String? = nil,
                givenName: String? = nil,
                extras: [String: String] = [:]) {
        self.id = id
        self.name = name
        self.email = email
        self.image = image
        self.familyName = familyName
        self.givenName = givenName
        self.extras = extras
    }
}
