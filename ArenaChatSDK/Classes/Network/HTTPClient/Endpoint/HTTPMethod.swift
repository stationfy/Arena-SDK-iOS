import Foundation

///  Restfull API HTTP Method
struct HTTPMethod: RawRepresentable, Equatable, Hashable {
    /// `DELETE` method.
    static let delete = HTTPMethod(rawValue: "DELETE")
    /// `GET` method.
    static let get = HTTPMethod(rawValue: "GET")
    /// `POST` method.
    static let post = HTTPMethod(rawValue: "POST")
    /// `PUT` method.
    static let put = HTTPMethod(rawValue: "PUT")

    let rawValue: String

    init(rawValue: String) {
        self.rawValue = rawValue
    }
}
