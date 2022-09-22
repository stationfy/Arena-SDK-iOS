import Foundation

enum CacheAPIEndpoint: EndpointSetuping {

    case requestEvent(writeKey: String, channel: String)

    var endpoint: String {
        switch self {
        case .requestEvent(writeKey: let writeKey, channel: let channel):
            return "v1/chatroom/\(writeKey)/\(channel)"
        }
    }

    var method: HTTPMethod {
        .get
    }
}

