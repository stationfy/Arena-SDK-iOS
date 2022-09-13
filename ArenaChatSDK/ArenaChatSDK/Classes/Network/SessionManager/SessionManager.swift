import Combine
import Foundation
import KeychainSwift

public protocol SessionClearable {
    var accessToken: String? { get }
    func clear()
}

public protocol SessionSavable {
    func save(_ session: AuthenticationData)
    func generateAnonymousId() -> String
}

public protocol SessionConsultable {
    var isLogged: Bool { get }
    var loggedUser: LoggedUser? { get }
    var session: AuthenticationData? { get }
}

public typealias SessionManageable = SessionSavable & SessionClearable & SessionConsultable

public final class SessionManager: SessionManageable, ObservableObject {
    private let keychain: KeychainManageable
    private let sessionKey = "sessionKey"

    @Published public var isLogged: Bool = false

    public var accessToken: String? { return session?.accessToken }

    public var loggedUser: LoggedUser? { return session?.user }

    public var session: AuthenticationData? {
        let session = value(AuthenticationData.self, forKey: sessionKey)
        return session
    }

    public init(keychain: KeychainManageable = KeychainSwift(keyPrefix: "arenChatApp_")) {
        self.keychain = keychain
        updateLoggedState(with: session != nil)
    }

    public func save(_ session: AuthenticationData) {
        set(encodable: session, forKey: sessionKey)
        updateLoggedState(with: true)
    }

    public func clear() {
        keychain.delete(for: sessionKey)
        updateLoggedState(with: false)
    }

    public func generateAnonymousId() -> String {
        if let storedUUID = accessToken {
            return storedUUID
        }

        let uuid: String

        if let vendorId = UIDevice.current.identifierForVendor?.uuidString {
            uuid = vendorId
        } else {
            uuid = UUID().uuidString
        }

        return uuid
    }

    private func set<T: Encodable>(encodable: T, forKey key: String) {
        if let data = try? JSONEncoder().encode(encodable) {
            keychain.set(data, forKey: key)
        }
    }

    private func value<T: Decodable>(_ type: T.Type, forKey key: String) -> T? {
        if let data = keychain.getData(key),
           let value = try? JSONDecoder().decode(type, from: data) {
            return value
        }
        return nil
    }

    private func updateLoggedState(with newValue: Bool) {
        if isLogged != newValue {
            isLogged = newValue
        }
    }
}
