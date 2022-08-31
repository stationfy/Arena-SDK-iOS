import Foundation

public protocol StreamDatable {

    var eventId: String { get }
    var pagination: Int { get }
    var collection: String { get }
    var descending: Bool { get }
}
