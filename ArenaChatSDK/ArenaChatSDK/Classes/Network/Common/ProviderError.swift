import Foundation

public enum ProviderError: Error {
    case emptyResponse
    case invalidUrlFormat
    case parsingError
    case requestFailed
    case requestCodeFailed
    case unableToGenerateUrl
    case unknownError
    case firebaseNotConfigured
}

public typealias ProviderResult<T> = Result<T, ProviderError>
