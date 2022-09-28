import Foundation

public enum API {
    public struct Version: RawRepresentable {
        private(set) public var rawValue: String

        public init?(rawValue: String) {
            self.rawValue = rawValue
        }
    }

    public struct Path: RawRepresentable {
        private(set) public var rawValue: String

        public init?(rawValue: String) {
            self.rawValue = rawValue
        }
    }
}

extension API.Version: CustomStringConvertible {
    public var description: String { return self.rawValue }
    public static var none: API.Version { return API.Version(rawValue: "")! }
}

extension API.Path: CustomStringConvertible {
    public var description: String { return self.rawValue }
    public static var none: API.Path { return API.Path(rawValue: "")! }
}
