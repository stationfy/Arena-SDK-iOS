import Foundation

struct MessageContentMedia: Decodable {
    let url: String?
    let description: String?
    let html: String?
    let providerName: String?
    let providerUrl: String?
    let thumbnailHeight: Int?
    let thumbnailUrl: String?
    let thumbnailWidth: Int?
    let title: String?
    let videoUrl: String?
    let type: String?
    let isVideo: Bool?

    init(url: String? = nil,
         description: String? = nil,
         html: String? = nil,
         providerName: String? = nil,
         providerUrl: String? = nil,
         thumbnailHeight: Int = 0,
         thumbnailUrl: String? = nil,
         thumbnailWidth: Int = 0,
         title: String? = nil,
         videoUrl: String? = nil,
         type: String? = nil,
         isVideo: Bool = false) {
        self.url = url
        self.description = description
        self.html = html
        self.providerName = providerName
        self.providerUrl = providerUrl
        self.thumbnailHeight = thumbnailHeight
        self.thumbnailUrl = thumbnailUrl
        self.thumbnailWidth = thumbnailWidth
        self.title = title
        self.videoUrl = videoUrl
        self.type = type
        self.isVideo = isVideo
    }
}
