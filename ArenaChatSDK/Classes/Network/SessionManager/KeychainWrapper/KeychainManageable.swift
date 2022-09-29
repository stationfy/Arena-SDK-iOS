import Foundation
import KeychainSwift

protocol KeychainManageable {
    func set(_ value: Data, forKey key: String)
    func getData(_ key: String) -> Data?
    func delete(for key: String)
}

extension KeychainSwift: KeychainManageable {
    public func set(_ value: Data, forKey key: String) {
        set(value, forKey: key, withAccess: nil)
    }

    public func getData(_ key: String) -> Data? {
        getData(key, asReference: false)
    }

    public func delete(for key: String) {
        delete(key)
    }
}
