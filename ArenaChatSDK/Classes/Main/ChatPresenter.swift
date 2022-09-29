//  Copyright

import Apollo
import FirebaseFirestore
import Foundation
import SocketIO

protocol ChatPresenting: class {
    func performUpdate(with batchUpdate: BatchUpdates, lastIndex: Int)
    func updateUsersOnline(count: String)
    func updateProfileImage(with stringUrl: String?)
    func startLoading()
    func stopLoading()
    func nextPageDidLoad()
    func showLoadMore()
    func hideLoadMore()
    func openLoginModal()
    func showReplyModal(receiver: String, message: String)
    func hideReplyModal()
    func openProfile(userName: String)
}

class ChatPresenter {
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

    private var repliedMessageKey: String?
    private var listIsLoading: Bool = false

    private weak var delegate: ChatPresenting?

    var numberOfRows: Int {
        filteredCards.count
    }

    init(arenaChat: ArenaChat = ArenaChat.shared, delegate: ChatPresenting) {
        guard let writeKey = arenaChat.writeKey,
              let channel = arenaChat.channel else {
            fatalError("ArenaChat `setup(writeKey: String, channel: String)` was not configured on AppDelegate")
        }

        self.writeKey = writeKey
        self.channel = channel

        self.delegate = delegate

        self.sessionManager = SessionManager()

        let cachedHttpClient = HTTPClient(
            baseUrl: arenaChat.configuration.cachedBaseURL,
            sessionManager: sessionManager,
            logger: Logger(isEnabled: true)
        )
        let userHttpClient = HTTPClient(
            baseUrl: arenaChat.configuration.chatBaseURL,
            sessionManager: sessionManager,
            logger: Logger(isEnabled: true)
        )

        let socketManager = SocketManager(
            socketURL: URL(string: arenaChat.configuration.socketBaseURL)!,
            config: [.log(true), .compress, .forceNew(true), .forceWebsockets(true)]
        )

        self.cachedService = CachedAPIService(client: cachedHttpClient)
        self.userService = UserService(client: userHttpClient, manager: socketManager)

        let interceptor = HeaderAddingInterceptor()
        self.chatService = ChatGraphQLService(
            client: ApolloClient.build(
                url: URL(string: arenaChat.configuration.graphQLBaseURL)!,
                interceptor: interceptor
            ),
            interceptor: interceptor
        )

        self.usersOnline()
    }

    func setUser(_ externalUser: ExternalUser) {
        self.externalUser = externalUser
    }

    func startEvent() {
        delegate?.startLoading()
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

    func registerUser(externalUser: ExternalUser) {
        self.externalUser = externalUser
        registerUser(externalUser)
        delegate?.startLoading()
    }

    func registerUser(name: String) {
        let userId = sessionManager.loggedUser?._id ?? sessionManager.generateAnonymousId()
        registerUser(ExternalUser(id: userId, name: name))
    }

    func registerAnonymousUser() {
        registerUser(ExternalUser(id: sessionManager.generateAnonymousId()))
        delegate?.startLoading()
    }

    func cellModel(for indexPath: IndexPath) -> Card {
        return filteredCards[indexPath.row]
    }

    func requestNextPage() {
        guard stream?.isLastPage == false,
              !listIsLoading,
              let chatInfo = event?.chatInfo,
              let chatRoomId = chatInfo.id,
              let channelId = chatInfo.mainChannelId else {
            // TODO: Error handling
            return
        }
        print("CALLED loadPreviousMessages")
        listIsLoading = true
        stream?.loadPreviousMessages(chatRoomId: chatRoomId, channelId: channelId)
    }

    func sendMessage(
        text: String?,
        mediaUrl: String?,
        isGif: Bool
    ) {
        if let repliedMessageKey = self.repliedMessageKey {
            replyChatMessage(text: text, replyId: repliedMessageKey, mediaUrl: mediaUrl, isGif: isGif)
            closeReplyMessage()
        } else {
            sendChatMessage(text: text, mediaUrl: mediaUrl, isGif: isGif)
        }
    }

    func openReplyMessage(index: Int) {
        guard let repliedMessageKey = filteredCards[index].chatMessage.key,
              let repliedName = filteredCards[index].chatMessage.sender?.displayName,
              let repliedMessage = filteredCards[index].chatMessage.content?.text else {
            // TODO: Error handling
            return
        }

        self.repliedMessageKey = repliedMessageKey
        delegate?.showReplyModal(receiver: repliedName, message: repliedMessage)
    }

    func closeReplyMessage() {
        self.repliedMessageKey = nil
        delegate?.hideReplyModal()
    }

    func setupProfile() {
        delegate?.openProfile(userName: loggedUser?.name ?? "")
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
                                userId: self.sessionManager.loggedUser?._id,
                                eventId: self.event?.eventInfo?.key,
                                dateFormat: self.event?.eventInfo?.summaryWordEvent,
                                summaryWord: self.event?.publisher?.config?.dateFormat)


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
            let lastIndex = self.filteredCards.count - 1

            DispatchQueue.main.sync { [weak self] in
                self?.listIsLoading = false
                self?.delegate?.performUpdate(with: batchUpdates, lastIndex: lastIndex)
                self?.delegate?.nextPageDidLoad()
                self?.delegate?.stopLoading()
                if shouldShowLoadMore {
                    self?.delegate?.showLoadMore()
                } else {
                    self?.delegate?.hideLoadMore()
                }
            }
        }
    }

    func stream(_ stream: ChatStreamProvider, didReceivedError error: Error) {
        print(error)
        // TODO: ERROR handling
    }
}

// MARK: Stream Context
fileprivate extension ChatPresenter {
    private func createStream() {
        guard let chatInfo = event?.chatInfo,
              let chatRoomId = chatInfo.id,
              let channelId = chatInfo.mainChannelId else {
            // TODO: Error handling
            return
        }

        do {
            let chatStream = try ChatStreamProvider()
            chatStream.delegate = self
            chatStream.startListeningRecentMessages(chatRoomId: chatRoomId,
                                                    channelId: channelId)

            self.stream = chatStream
        } catch let error {
            delegate?.stopLoading()
            // TODO: Error handling
            print(error)
        }



    }
}

// MARK: User Context
fileprivate extension ChatPresenter {

    func validateUser() {
        if loggedUser != nil {
            createStream()
        } else if let externalUser = externalUser {
            registerUser(externalUser)
        } else {
            delegate?.stopLoading()
            delegate?.openLoginModal()
        }
    }

    func registerUser(_ externalUser: ExternalUser) {
        userService.add(writeKey: writeKey,
                        externalUser: externalUser) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(authResponse):
                self.sessionManager.save(authResponse.data)

                let loggedUser = authResponse.data.user
                self.loggedUser = loggedUser
                self.delegate?.updateProfileImage(with: loggedUser.profile?.profileImage)

                if (self.changedUser) {
                    self.changeUser(loggedUser)
                } else {
                    self.joinUser(loggedUser)
                }

            case let .failure(error):
                self.delegate?.stopLoading()
                self.delegate?.openLoginModal()
                // TODO: Error handling
                print(error)
                break
            }
        }
    }

    func changeUser(_ loggerUser: LoggedUser) {
        self.userService.update(userId: loggedUser?._id,
                                isAnonymous: loggedUser?._id?.isEmpty ?? true,
                                name: loggedUser?.name,
                                image: loggedUser?.image) { [weak self] result in
            self?.changedUser = false

            switch result {
            case .success:
                self?.startEvent()
            case let .failure(error):
                self?.delegate?.stopLoading()
                print(error)
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
                              image: loggedUser?.image) { [weak self] result in
            switch result {
            case .success:
                self?.startEvent()
            case let .failure(error):
                print(error)
                self?.delegate?.stopLoading()
                // TODO: Error handling
                break
            }
        }
    }

    func usersOnline() {
        self.userService.onlineChatInformation { [weak self] result in
            switch result {
            case let .success(presenceInfo):
                let onlineCount = presenceInfo.onlineCount ?? 0
                var countString = "\(onlineCount)"

                if (presenceInfo.onlineCount ?? 0) >= 1000 {
                    let formatedOnlineCount = floor(Double(onlineCount / 1000))
                    countString = "\(formatedOnlineCount)K"
                }

                self?.delegate?.updateUsersOnline(count: countString)
            case let .failure(error):
                print(error)
                // TODO: Error handling
                break
            }
        }
    }

}

// MARK: Sending Message Context
fileprivate extension ChatPresenter {
    func sendChatMessage(
        text: String?,
        mediaUrl: String?,
        isGif: Bool
    ) {
        guard let text = text,
              let graphqlPubApiKey = event?.settings?.graphqlPubApiKey,
              let siteId = event?.chatInfo?.siteId,
              let openChannelId = event?.chatInfo?.mainChannelId else {
            // TODO: Error handling
            return
        }

        chatService.sendMessage(
            channelId: openChannelId,
            siteId: siteId,
            graphqlPubApiKey: graphqlPubApiKey,
            messageText: text,
            photoUrl: loggedUser?.image,
            mediaUrl: mediaUrl,
            displayName: loggedUser?.name,
            userId: loggedUser?._id ?? sessionManager.loggedUser?._id ?? "",
            token: sessionManager.accessToken,
            isGif: isGif
        ) { result in
            switch result {
            case let .success(message):
                print(message)
            case let .failure(error):
                print(error)
            }
        }
    }

    func replyChatMessage(
        text: String?,
        replyId: String,
        mediaUrl: String?,
        isGif: Bool
    ) {
        guard let text = text,
              let graphqlPubApiKey = event?.settings?.graphqlPubApiKey,
              let siteId = event?.chatInfo?.siteId,
              let openChannelId = event?.chatInfo?.mainChannelId else {
            // TODO: Error handling
            return
        }

        chatService.replyMessage(
            channelId: openChannelId,
            siteId: siteId,
            graphqlPubApiKey: graphqlPubApiKey,
            messageText: text,
            photoUrl: loggedUser?.image,
            mediaUrl: mediaUrl,
            displayName: loggedUser?.name,
            userId: loggedUser?._id ?? sessionManager.loggedUser?._id ?? "",
            replyId: replyId,
            token: sessionManager.accessToken,
            isGif: isGif
        ) { result in
            switch result {
            case let .failure(error):
                print(error)
            default: break
            }
        }
    }
}
