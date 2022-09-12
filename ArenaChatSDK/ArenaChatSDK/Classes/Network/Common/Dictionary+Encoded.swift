import Foundation

extension Dictionary {
    func toData() throws -> Data {
        try JSONSerialization.data(withJSONObject: self)
    }
}

extension Encodable {
    var data: Data? {
        try? JSONEncoder().encode(self)
    }

    var dictionary: [String: Any]? {
        guard let data = self.data else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}
