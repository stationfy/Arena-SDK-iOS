import Foundation

public typealias HTTPHeader = [String: String]

extension HTTPHeader {

    /// Returns a `Bearer` `Authorization` header using the `bearerToken` provided
    ///
    /// - Parameter bearerToken: The bearer token.
    ///
    /// - Returns: The header.
    static func authorization(bearerToken: String) -> HTTPHeader {
        authorization("Bearer \(bearerToken)")
    }

    /// Returns an `Authorization` header.
    ///
    /// Provides built-in methods to produce `Authorization` headers. For a `Authorization` header, use
    /// `HTTPHeader.authorization(bearerToken:)`.
    ///
    /// - Parameter value: The `Authorization` value.
    ///
    /// - Returns: The header.
    static func authorization(_ value: String) -> HTTPHeader {
        ["Authorization": value]
    }
}
