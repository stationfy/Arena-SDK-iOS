import Foundation

protocol EndpointSetuping {
    var version: API.Version { get }
    var path: API.Path { get }
    var endpoint: String { get }
    var parameters: Parameters? { get }
    var method: HTTPMethod { get }
    var header: HTTPHeader { get }
    var isAuthenticated: Bool { get }
}

extension EndpointSetuping {
    var version: API.Version { .none }
    var path: API.Path { .none }
    var parameters: Parameters? { nil }
    var header: HTTPHeader { [:] }
    var isAuthenticated: Bool { false }
}
