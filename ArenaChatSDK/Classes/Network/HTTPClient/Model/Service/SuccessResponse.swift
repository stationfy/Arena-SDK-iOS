import Foundation

struct SuccessResponse: Decodable {
    let response: String?

    init(response: String?) {
        self.response = response
    }
}
