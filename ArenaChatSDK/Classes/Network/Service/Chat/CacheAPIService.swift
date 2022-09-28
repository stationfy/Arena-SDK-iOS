import Foundation
import Apollo

protocol CachedAPIServicing {
    func fetchEvent(writeKey: String,
                    channel: String,
                    completion: @escaping (Result<Event, ServiceError>) -> Void)
}

struct CachedAPIService {

    private let client: ClientRequestable

    init(client: ClientRequestable) {
        self.client = client
    }
}

extension CachedAPIService: CachedAPIServicing {
    func fetchEvent(writeKey: String,
                    channel: String,
                    completion: @escaping (Result<Event, ServiceError>) -> Void) {
        let endpointSetup = CacheAPIEndpoint.requestEvent(writeKey: writeKey,
                                                          channel: channel)
        client.request(setup: endpointSetup, completion: completion)
    }
}
