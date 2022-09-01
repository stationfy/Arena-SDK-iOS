import Foundation

public struct FailureResponse: Decodable {
    public let message: String?
    public let status: String
}
