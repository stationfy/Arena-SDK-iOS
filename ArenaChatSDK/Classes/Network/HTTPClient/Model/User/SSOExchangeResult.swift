import Foundation

struct SSOExchangeResult: Decodable {
    let user: LoggedUser
    let token: String?
    let firebaseToken: String?
}
