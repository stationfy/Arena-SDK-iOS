import Foundation

struct FailureResponse: Decodable {
    let message: String?
    let status: String
}
