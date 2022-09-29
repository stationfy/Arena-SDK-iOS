import Foundation

enum ProviderError: Error {
    case emptyResponse
    case invalidUrlFormat
    case parsingError
    case requestFailed
    case requestCodeFailed
    case unableToGenerateUrl
    case unknownError
    case firebaseNotConfigured
}

typealias ProviderResult<T> = Result<T, ProviderError>
