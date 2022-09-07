import Foundation

protocol CachedAPIServicing {
    func fetchEvent(publisherSlug: String,
                    eventSlug: String,
                    completion: @escaping (Result<Event, ServiceError>) -> Void)
}

struct CachedAPIService {

    private let client: ClientRequestable

    init(client: ClientRequestable) {
        self.client = client
    }
}

extension CachedAPIService: CachedAPIServicing {
    func fetchEvent(publisherSlug: String,
                    eventSlug: String,
                    completion: @escaping (Result<Event, ServiceError>) -> Void) {
        let endpointSetup = CacheAPIEndpoint.requestEvent(eventSlug: eventSlug,
                                                          publisherSlug: publisherSlug)
        client.request(setup: endpointSetup, completion: completion)
    }
}
