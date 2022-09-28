import Foundation

struct PublisherFeatureFlag: Decodable {
    let status: String?
}

enum PublisherFeature: String, Decodable {
    case instagramStream = "instagram_stream"
    case newPresence = "new_presence"
    case soccerWidgets = "soccer_widgets"
    case useFirestore = "use_firestore"
}
