import Foundation

struct MessageContent: Decodable {
    let text: String?
    let media: MessageContentMedia?
}
