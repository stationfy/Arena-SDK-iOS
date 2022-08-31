import Foundation

struct MessageContentMedia: Decodable {
    let url: String?
    let description: String?
    let html: String?
    let providerName: String?
    let providerUrl: String?
    let thumbnailHeight: Int
    let thumbnailUrl: String?
    let thumbnailWidth: Int
    let title: String?
    let videoUrl: String?
    let type: String?
    let isVideo: Bool
}
