import Foundation

enum ChatStreamData: StreamDatable {
    case channels(eventId: String, pagination: Int, descending: Bool)

    var eventId: String {
        switch self {
        case .channels(let eventId, _, _):
            return eventId
        }
    }

    var collection: String {
        switch self {
        case .channels:
            return "channels"
        }
    }

    var pagination: Int {
        switch self {
        case .channels(_, let pagination, _):
            return pagination
        }
    }

    var descending: Bool {
        switch self {
        case .channels(_, _, let descending):
            return descending
        }
    }
}
