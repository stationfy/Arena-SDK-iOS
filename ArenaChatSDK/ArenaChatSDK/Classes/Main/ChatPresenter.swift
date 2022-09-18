//  Copyright

import Apollo
import FirebaseFirestore
import Foundation
import SocketIO

public protocol ChatPresenting: class {
    func performUpdate(with batchUpdate: BatchUpdates)
    func nextPageDidLoad()
    func showLoadMore()
    func hideLoadMore()

    func openLoginModal()
}

public class ChatPresenter {
    static let pollUpdatedNotification = Notification.Name("ArenaChat.pollUpdatedNotification")
    static let reactionUpdatedNotification = Notification.Name("ArenaChat.reactionUpdatedNotification")

    private let serialQueue = DispatchQueue(label: "im.arena.chat.updatethread", qos: .utility)

    private let writeKey: String
    private let channel: String

    private var loggedUser: LoggedUser?
    private var externalUser: ExternalUser?

    private var changedUser: Bool = false

    private let sessionManager: SessionManageable

    private let cachedService: CachedAPIServicing
    private let userService: UserServicing
    private let chatService: ChatGraphQLServicing
    private var stream: ChatStreamProvider?
    private var event: Event?

    private var cards: [Card] = []
    private var filteredCards: [Card] = []

    weak var delegate: ChatPresenting?

    var numberOfRows: Int {
        filteredCards.count
    }

    public init(writeKey: String, channel: String, delegate: ChatPresenting) {
        self.writeKey = writeKey
        self.channel = channel
        self.delegate = delegate

        self.sessionManager = SessionManager()

        let httpClient = HTTPClient(baseUrl: "",
                                    sessionManager: sessionManager,
                                    logger: Logger(isEnabled: true))
        let socketManager = SocketManager(socketURL: URL(string: "http://localhost:8080")!,
                                          config: [.log(true), .compress])

        self.cachedService = CachedAPIService(client: httpClient)
        self.userService = UserService(client: httpClient, manager: socketManager)

        let interceptor = HeaderAddingInterceptor()
        self.chatService = ChatGraphQLService(client: ApolloClient.build(interceptor: interceptor),
                                              interceptor: interceptor)
    }

    func setUser(_ externalUser: ExternalUser) {
        self.externalUser = externalUser
    }

    func cellModel(for indexPath: IndexPath) -> Card {
        return filteredCards[indexPath.row]
    }

    public func startEvent() {
        cachedService.fetchEvent(writeKey: writeKey,
                                 channel: channel) { [weak self] result in
            switch result {
            case let .success(event):
                self?.event = event
                self?.validateUser()
            case .failure:
                // TODO: Error handling
                break
            }
        }
    }

    public func requestNextPage() {
        stream?.requestNextEvents()
    }

    public func registerUser(name: String) {
        registerUser(ExternalUser(id: sessionManager.generateAnonymousId(),
                                  name: name))
    }

    public func registerAnonymous() {
        registerUser(ExternalUser(id: sessionManager.generateAnonymousId()))
    }

    public func sendMessage(
        text: String,
        mediaUrl: String?,
        isGif: Bool
    ) {
        guard let graphqlPubApiKey = event?.settings?.graphqlPubApiKey,
              let siteId = event?.chatInfo?.siteId,
              let openChannelId = event?.chatInfo?.mainChannelId else {
            // TODO: Error handling
            return
        }

        chatService.sendMessage(channelId: openChannelId,
                                siteId: siteId,
                                graphqlPubApiKey: graphqlPubApiKey,
                                messageText: text,
                                photoUrl: loggedUser?.image,
                                mediaUrl: mediaUrl,
                                displayName: loggedUser?.name,
                                userId: loggedUser?._id ?? sessionManager.loggedUser?._id ?? "",
                                token: sessionManager.accessToken,
                                isGif: isGif) { result in

        }
    }

    public func replyMessage(
        text: String,
        replyId: String,
        mediaUrl: String?,
        isGif: Bool
    ) {
        guard let graphqlPubApiKey = event?.settings?.graphqlPubApiKey,
              let siteId = event?.chatInfo?.siteId,
              let openChannelId = event?.chatInfo?.mainChannelId else {
            // TODO: Error handling
            return
        }

        chatService.replyMessage(channelId: openChannelId,
                                 siteId: siteId,
                                 graphqlPubApiKey: graphqlPubApiKey,
                                 messageText: text,
                                 photoUrl: loggedUser?.image,
                                 mediaUrl: mediaUrl,
                                 displayName: loggedUser?.name,
                                 userId: loggedUser?._id ?? sessionManager.loggedUser?._id ?? "",
                                 replyId: replyId,
                                 token: sessionManager.accessToken,
                                 isGif: isGif) { result in

        }
    }
}

extension ChatPresenter: ChatStreamDelegate {
    func stream(_ stream: ChatStreamProvider,
                didReceivedMessages messages: [MessageResponse],
                isReloading: Bool) {
        serialQueue.async { [weak self] in
            guard let self = self else { return }
            let oldCards = self.cards
            var reloadModuleIds = Set<String>()
            if isReloading {
                self.cards = []
            }
            messages.forEach { messageResponse in

                let card = Card(chatMessage: messageResponse.message,
                                userId: nil,
                                eventId: self.event?.eventInfo.key,
                                dateFormat: self.event?.eventInfo.summaryWordEvent,
                                summaryWord: self.event?.publisher.config?.dateFormat)


                switch messageResponse.action {
                case let .added(index):
                    let newIndex = Int(index)
                    self.cards.insert(card, at: newIndex)
                case let .removed(index):
                    let newIndex = Int(index)
                    self.cards.remove(at: newIndex)
                case let .modified(fromIndex, toIndex):
                    let newIndex = Int(toIndex)
                    //var shouldReload = true
                    if fromIndex != toIndex {
                        let oldIndex = Int(fromIndex)
                        self.cards[oldIndex] = self.cards[newIndex]
                        reloadModuleIds.insert(self.cards[newIndex].chatMessage.key?.lowercased() ?? "")
                    } else {
                        // TODO
                        //                        let oldCard = self.cards[newIndex]
                        //                        if oldCard.chatMessage.key == card.chatMessage.key {
                        //                            if card.type == .poll {
                        //                                shouldReload = false
                        //                                NotificationCenter.default.post(name: LiveblogDataStream.pollUpdatedNotification, object: card)
                        //                            } else if card.reaction != oldCard.reaction {
                        //                                shouldReload = false
                        //                                NotificationCenter.default.post(name: LiveblogDataStream.reactionUpdatedNotification, object: card)
                        //                            }
                        //                        }

                    }
                    //if shouldReload {
                    reloadModuleIds.insert(card.chatMessage.key?.lowercased() ?? "")
                    //}
                    
                    self.cards[newIndex] = card
                }
            }

            let shouldShowLoadMore = self.cards.count == stream.currentPageSize

            let batchUpdates = BatchUpdates.compare(oldValues: oldCards,
                                                    newValues: self.cards,
                                                    reloadModuleIds: reloadModuleIds)

            self.filteredCards = self.cards

            DispatchQueue.main.sync { [weak self] in
                self?.delegate?.performUpdate(with: batchUpdates)
                self?.delegate?.nextPageDidLoad()
                if shouldShowLoadMore {
                    self?.delegate?.showLoadMore()
                } else {
                    self?.delegate?.hideLoadMore()
                }
            }
        }
    }

    func stream(_ stream: ChatStreamProvider, didReceivedError error: Error) {
        // TODO: ERROR handling
    }
}

// MARK: Stream Context
fileprivate extension ChatPresenter {
    private func createStream() {
        guard let event = event else {
            // TODO: Error handling
            return
        }

        let streamData = ChatStreamData.channels(eventId: event.eventInfo.key,
                                                 pagination: 20,
                                                 descending: true)
        let chatStream = try! ChatStreamProvider(streamData: streamData)

        chatStream.delegate = self
        chatStream.startListeningEvents()

        self.stream = chatStream

    }
}
// MARK: User Context
fileprivate extension ChatPresenter {

    func validateUser() {
        if let externalUser = externalUser {
            registerUser(externalUser)
        } else if loggedUser != nil {
            createStream()
        } else {
            delegate?.openLoginModal()
        }
    }

    func registerUser(_ externalUser: ExternalUser) {
        userService.add(writeKey: writeKey,
                        externalUser: externalUser) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(loggedUser):
                self.loggedUser = loggedUser
                if let token = loggedUser.token {
                    self.sessionManager.save(AuthenticationData(accessToken: token,
                                                                user: loggedUser))
                }

                if (self.changedUser) {
                    self.changeUser(loggedUser)
                } else {
                    self.joinUser(loggedUser)
                }

            case .failure:
                // TODO: Error handling
                break
            }
        }
    }

    func changeUser(_ loggerUser: LoggedUser) {
        self.userService.update(userId: loggedUser?._id,
                                isAnonymous: loggedUser?._id?.isEmpty ?? true,
                                name: loggedUser?.name,
                                image: loggedUser?.image) { result in
            self.changedUser = false

            switch result {
            case .success:
                self.createStream()
            case .failure:
                // TODO: Error handling
                break
            }
        }
    }

    func joinUser(_ loggerUser: LoggedUser) {
        self.userService.join(channelId: event?.chatInfo?.id,
                              siteId: event?.chatInfo?.siteId,
                              userId: loggedUser?._id,
                              isAnonymous: loggedUser?._id?.isEmpty ?? true,
                              name: loggedUser?.name,
                              image: loggedUser?.image) { result in
            switch result {
            case .success:
                self.createStream()
            case .failure:
                // TODO: Error handling
                break
            }
        }
    }

}
