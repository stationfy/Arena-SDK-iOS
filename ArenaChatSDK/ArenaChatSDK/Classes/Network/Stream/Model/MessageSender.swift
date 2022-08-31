import Foundation

struct MessageSender: Decodable {
    let anonymousId: String?
    let label: String?
    let uid: String?
    let displayName: String?
    let photoURL: String?
    let isPublisher: Bool
}
