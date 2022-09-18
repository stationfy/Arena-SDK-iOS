import Apollo
import Foundation

enum ChatOperationFactory: OperationFactoring {
    case sendMessage(channelId: String,
                     messageText: String,
                     mediaUrl: String?,
                     displayName: String?,
                     userId: String,
                     isGif: Bool)
    case replyMessage(channelId: String,
                      messageText: String,
                      mediaUrl: String?,
                      displayName: String?,
                      userId: String,
                      replyId: String,
                      isGif: Bool)

    var operation: SendMessageMutation {
        switch self {
        case let .sendMessage(channelId,
                              messageText,
                              mediaUrl,
                              displayName,
                              userId,
                              isGif):

            return buldMutation(channelId: channelId,
                                messageText: messageText,
                                mediaUrl: mediaUrl,
                                displayName: displayName,
                                userId: userId,
                                isGif: isGif)

        case let .replyMessage(channelId,
                               messageText,
                               mediaUrl,
                               displayName,
                               userId,
                               replyId,
                               isGif):

            return buldMutation(channelId: channelId,
                                messageText: messageText,
                                mediaUrl: mediaUrl,
                                displayName: displayName,
                                userId: userId,
                                replyId: replyId,
                                isGif: isGif)

        }
    }

    func buldMutation(channelId: String,
                      messageText: String,
                      mediaUrl: String?,
                      displayName: String?,
                      userId: String,
                      replyId: String? = nil,
                      isGif: Bool) -> SendMessageMutation {
        SendMessageMutation(
            input: SendMessageInput(
                groupChannelId: channelId,
                message: MessageContentInput(
                    media: MessageMediaInput(
                        isGif: isGif,
                        url: mediaUrl),
                    text: messageText
                ),
                openChannelId: channelId,
                replyTo: replyId,
                sender: AnonymousSenderInput(
                    _id: userId,
                    name: displayName ?? ""
                ),
                slowMode: false,
                tempId: String(Int.random(in: Int.min..<Int.max)))
        )
    }
}
