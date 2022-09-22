import Foundation

public protocol StreamDatable {

    var parameters: [String: String] { get }
    var pagination: Int { get }
    var collection: String { get }
    var descending: Bool { get }
}
