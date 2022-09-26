import Foundation

struct PresenceInfo: Decodable {
    let channelId: String?
    let onlineCount: Int?
    let visitors: Visitors?
}
