import Foundation

struct BanUser: Encodable {
    let anonymousId: String?
    let name: String?
    let image: String?
    let siteId: String?
    let userId: String?
}
