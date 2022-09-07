import Foundation

struct Card {
    var chatMessage: Message
    let eventId: String?
    let dateFormat: String?
    let summaryWord: String?
    let createdAt: Date?
    let type: MessageType

    init(chatMessage: Message,
         userId: String?,
         eventId: String?,
         dateFormat: String?,
         summaryWord: String?) {

        self.chatMessage = chatMessage
        self.eventId = eventId
        self.dateFormat = dateFormat
        self.summaryWord = summaryWord

        if let timeStamp = chatMessage.createdAt {
            let timeInterval = TimeInterval(timeStamp / 1000)
            createdAt = Date(timeIntervalSince1970: timeInterval)
        } else {
            createdAt = nil
        }

        if chatMessage.type == "poll" {
            type = .poll
        } else if chatMessage.sender?.anonymousId == userId ||
                    chatMessage.sender?.uid == userId &&
                    chatMessage.replyMessage != nil {
            type = .senderReply
        } else if chatMessage.replyMessage != nil {
            type = .receivedReply
        } else if userId == nil {
            type = .received
        } else if chatMessage.sender?.anonymousId == userId {
            type = .sender
        } else {
            type = .received
        }
    }

}

enum MessageType: Int, Decodable {
    case sender = 4356
    case senderReply = 4352
    case date = 5623
    case poll = 5467
    case receivedReply = 3463
    case received = 7562
}
