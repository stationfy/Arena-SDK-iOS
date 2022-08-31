import Foundation

extension Dictionary {
    func toData() throws -> Data {
        try JSONSerialization.data(withJSONObject: self)
    }
}
