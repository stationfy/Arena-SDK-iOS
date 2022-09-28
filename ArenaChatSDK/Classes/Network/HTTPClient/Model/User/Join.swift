import Foundation


struct Join: Encodable {
    let channelId: String?
    let siteId: String?
    let channelType: String
    let user: User
}
