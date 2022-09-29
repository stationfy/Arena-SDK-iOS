import Combine
import Foundation
import KeychainSwift

protocol SessionClearable {
    var accessToken: String? { get }
    func clear()
}

protocol SessionSavable {
    func save(_ session: AuthenticationData)
    func generateAnonymousId() -> String
}

protocol SessionConsultable {
    var isLogged: Bool { get }
    var loggedUser: LoggedUser? { get }
    var session: AuthenticationData? { get }
}

typealias SessionManageable = SessionSavable & SessionClearable & SessionConsultable

final class SessionManager: SessionManageable, ObservableObject {
    private let keychain: KeychainManageable
    private let sessionKey = "sessionKey"

    @Published var isLogged: Bool = false


    var accessToken: String? { return session?.token }

    var loggedUser: LoggedUser? { return session?.user }

    var session: AuthenticationData? {
        let session = value(AuthenticationData.self, forKey: sessionKey)
        return session
    }

    init(keychain: KeychainManageable = KeychainSwift(keyPrefix: "arenChatApp_")) {
        self.keychain = keychain
        updateLoggedState(with: session != nil)
    }

    func save(_ session: AuthenticationData) {
        set(encodable: session, forKey: sessionKey)
        updateLoggedState(with: true)
    }

    func clear() {
        keychain.delete(for: sessionKey)
        updateLoggedState(with: false)
    }

    func generateAnonymousId() -> String {
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
