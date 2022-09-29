import Foundation

public enum API {
    struct Version: RawRepresentable {
        private(set) var rawValue: String

        init?(rawValue: String) {
            self.rawValue = rawValue
        }
    }

    struct Path: RawRepresentable {
        private(set) var rawValue: String

        init?(rawValue: String) {
            self.rawValue = rawValue
        }
    }
}

extension API.Version: CustomStringConvertible {
    var description: String { return self.rawValue }
    static var none: API.Version { return API.Version(rawValue: "")! }
}

extension API.Path: CustomStringConvertible {
    var description: String { return self.rawValue }
    static var none: API.Path { return API.Path(rawValue: "")! }
}
