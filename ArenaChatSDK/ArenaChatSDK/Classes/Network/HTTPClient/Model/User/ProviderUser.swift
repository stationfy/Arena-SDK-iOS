import Foundation

struct ProviderUser: Encodable {
    let provider: String?
    let username: String?
    let profile: Profile?
    let metadata: [String: String]?
}
