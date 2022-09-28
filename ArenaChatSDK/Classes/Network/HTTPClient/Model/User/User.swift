import Foundation

struct User: Codable {
    let userId: String?
    let isAnonymous: Bool
    let name: String?
    let country: String?
    let image: String?
    let isMobile: Bool
}
