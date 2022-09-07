import Foundation

enum CacheAPIEndpoint: EndpointSetuping {

    case requestEvent(eventSlug: String, publisherSlug: String)

    var endpoint: String {
        switch self {
        case .requestEvent(eventSlug: let eventSlug, publisherSlug: let publisherSlug):
            return "/v1/chat/\(publisherSlug)/\(eventSlug)"
        }
    }

    var method: HTTPMethod {
        .get
    }

    var parameters: Parameters? {
        switch self {
        case  .requestEvent:
            return ["fields": "eventInfo,publisher"]
        }

    }
}

