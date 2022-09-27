import Foundation
import SocketIO

protocol UserServicing {
    func add(writeKey: String,
             externalUser: ExternalUser,
             completion: @escaping (Result<AuthResponse, ServiceError>) -> Void)

    func join(channelId: String?,
              siteId: String?,
              userId: String?,
              isAnonymous: Bool,
              name: String?,
              image: String?,
              completion: @escaping (Result<Void, ServiceError>) -> Void)
    func update(userId: String?,
                isAnonymous: Bool,
                name: String?,
                image: String?,
                completion: @escaping (Result<Void, ServiceError>) -> Void)
    func onlineChatInformation(completion: @escaping (Result<PresenceInfo, ServiceError>) -> Void)
}

struct UserService: UserServicing {

    private let client: ClientRequestable
    private let manager: SocketManager
    private let socket: SocketIOClient

    private let eventJoin: String = "join"
    private let userSetData: String = "user.setdata"
    private let eventInfo: String = "presence.info"

    init(client: ClientRequestable,
         manager: SocketManager) {
        self.client = client
        self.manager = manager
        self.socket = self.manager.defaultSocket

    }
}

// MARK: HTTPServices
extension UserService {
    func add(writeKey: String,
             externalUser: ExternalUser,
             completion: @escaping (Result<AuthResponse, ServiceError>) -> Void) {
        let providerUser = ProviderUser(
            provider: writeKey,
            username: externalUser.name,
            profile: Profile(
                urlName: externalUser.name,
                email: externalUser.email,
                username: externalUser.id,
                displayName: externalUser.name,
                name: Name(
                    familyName: recoverFamilyName(name: externalUser.name),
                    givenName: recoverGivenName(name: externalUser.name)
                ),
                profileImage: externalUser.image,
                id: externalUser.id
            ),
            metadata: externalUser.extras
        )

        let endpointSetup = UserEndpoint.add(providerUser: providerUser)
        client.request(setup: endpointSetup, completion: completion)
    }

}

// MARK: SocketServices {
extension UserService {

    func join(channelId: String?,
              siteId: String?,
              userId: String?,
              isAnonymous: Bool,
              name: String?,
              image: String?,
              completion: @escaping (Result<Void, ServiceError>) -> Void) {

        let join = Join(
            channelId: channelId,
            siteId: siteId,
            channelType: "chat_room",
            user: User(
                userId: userId,
                isAnonymous: isAnonymous,
                name: name,
                country: nil,
                image: image,
                isMobile: true
            )
        )

        guard let data = join.dictionary else {
            completion(.failure(.responseEncondingFailure("Data parse failed")))
            return
        }

        socket.emit(eventJoin, data)
        completion(.success(()))
    }

    func update(userId: String?,
                isAnonymous: Bool,
                name: String?,
                image: String?,
                completion: @escaping (Result<Void, ServiceError>) -> Void) {

        let user = User(
            userId: userId,
            isAnonymous: isAnonymous,
            name: name,
            country: nil,
            image: image,
            isMobile: true
        )

        guard let data = user.dictionary else {
            completion(.failure(.responseEncondingFailure("Data parse failed")))
            return
        }

        socket.emit(userSetData, data)

        completion(.success(()))
    }

    func onlineChatInformation(completion: @escaping (Result<PresenceInfo, ServiceError>) -> Void) {
        socket.onAny { event in
            print("Hanlde any Socket event: \(event)")
        }

        socket.on(eventInfo) { data, ack in
            guard let dictionary = data.first as? [String: Any] else {
                completion(.failure(.responseEncondingFailure("Data parse failed")))
                return
            }

            do {
                let dataObject = try dictionary.toData()
                let presenceInfo: PresenceInfo = try dataObject.parse()
                completion(.success(presenceInfo))
            } catch let error {
                completion(.failure(.responseEncondingFailure(error.localizedDescription)))
            }
        }

        self.socket.connect()
    }

}

// MARK: Private Functions
fileprivate extension UserService {
    func recoverFamilyName(name: String?) -> String? {
        var nameSplitList = name?.split(separator: " ")
        nameSplitList?.removeFirst()

        return nameSplitList?.joined(separator: " ")
    }

    func recoverGivenName(name: String?) -> String? {
        guard let nameSplitList = name?.split(separator: " "),
              let substring = nameSplitList.first else {
            return nil
        }

        return String(substring)
    }
}
