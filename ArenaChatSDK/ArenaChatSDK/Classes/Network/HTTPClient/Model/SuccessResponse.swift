import Foundation

public struct SuccessResponse: Decodable {
    public let response: String?

    public init(response: String?) {
        self.response = response
    }
}
