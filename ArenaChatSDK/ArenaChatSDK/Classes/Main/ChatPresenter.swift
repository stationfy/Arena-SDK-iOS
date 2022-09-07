//  Copyright

import Foundation
import FirebaseFirestore

protocol ChatPresenting: class {

    func performUpdate(with batchUpdate: BatchUpdates)
    func nextPageDidLoad()
    func showLoadMore()
    func hideLoadMore()
}

public class ChatPresenter {
    static let pollUpdatedNotification = Notification.Name("ArenaLiveblog.pollUpdatedNotification")
    static let reactionUpdatedNotification = Notification.Name("ArenaLiveblog.reactionUpdatedNotification")

    private let serialQueue = DispatchQueue(label: "im.arena.updatethread", qos: .utility)
    private let eventSlug: String
    private let service: CachedAPIServicing
    private var stream: ChatStreamProvider?
    private var event: Event?

    private var cards: [Card] = []
    private var filteredCards: [Card] = []

    weak var delegate: ChatPresenting?

    var numberOfRows: Int {
        filteredCards.count
    }

    public init(eventSlug: String) {
        self.eventSlug = eventSlug
        self.service = CachedAPIService(client: HTTPClient(baseUrl: "",
                                                           sessionManager: SessionManager(),
                                                           logger: Logger(isEnabled: true)))
    }

    init(eventSlug: String, service: CachedAPIServicing) {
        self.service = service
        self.eventSlug = eventSlug
    }

    func cellModel(for indexPath: IndexPath) -> Card {
        return filteredCards[indexPath.row]
    }

    public func startEvent() {
        guard let publisherSlug = ArenaChat.shared.publisherSlug else {
            // TODO: Error handling
            return
        }
        service.fetchEvent(publisherSlug: publisherSlug,
                           eventSlug: eventSlug) { [weak self] result in
                            switch result {
                            case .success(let event):
                                self?.createStream(fromEvent: event)
                            case .failure:
                                // TODO: Error handling
                                break
                            }
        }
    }

    public func requestNextPage() {
        stream?.requestNextEvents()
    }

    private func createStream(fromEvent event: Event) {

        let streamData = ChatStreamData.channels(eventId: event.eventInfo.key,
                                             pagination: 20,
                                             descending: true)
        let chatStream = try! ChatStreamProvider(streamData: streamData)

        chatStream.delegate = self
        chatStream.startListeningEvents()

        self.event = event

        self.stream = chatStream

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
                    var shouldReload = true
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
                    if shouldReload {
                        reloadModuleIds.insert(card.chatMessage.key?.lowercased() ?? "")
                    }
                    
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
