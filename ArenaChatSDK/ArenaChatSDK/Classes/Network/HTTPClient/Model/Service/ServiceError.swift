import Foundation

public enum ServiceError: Error {

    case authenticationRequired
    case emptyData
    case hostNotFound
    case badRequest
    case invalidHttpUrlResponse
    case invalidBaseUrl
    case invalidUrl
    case alreadyExist
    case parameterUrlEncodingNotFound
    case parameterJsonEncodingFailure(String)
    case brokenData(Int)
    case notConnectedToInternet(String)
    case requestFailure(FailureResponse)
    case responseEncondingFailure(String)
    case graphQLError(String)
    case unknown(String)

    public var localizedDescription: String {
        switch self {
        case .authenticationRequired: return "Authentication is required."
        case .emptyData: return "Empty Data."
        case .hostNotFound: return "The host was not found."
        case .badRequest: return "This is a bad request."
        case .invalidHttpUrlResponse: return "HTTPURLResponse is invalid."
        case .invalidBaseUrl: return "Base URL is invalid."
        case .invalidUrl: return "URL is invalid."
        case .alreadyExist: return "Already exist."
        case .parameterUrlEncodingNotFound: return "Enconded URL not found"
        case let .parameterJsonEncodingFailure(message): return "The received data is broken. Status code " + ": \(message)"
        case let .brokenData(statusCode): return "The received data is broken. Status code \(statusCode)"
        case let .notConnectedToInternet(message): return message
        case let .requestFailure(response): return response.message ?? "Request Failure: Missing message"
        case let .responseEncondingFailure(message): return "Can not enconde response data. " + message
        case let .graphQLError(message): return "GraphQL Failure. " + message
        case let .unknown(message): return message
        }
    }
}

extension ServiceError: Equatable {
    public static func == (lhs: ServiceError, rhs: ServiceError) -> Bool {
        return lhs.localizedDescription == rhs.localizedDescription
    }
}
