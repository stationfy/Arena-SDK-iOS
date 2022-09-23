import Foundation
import Apollo

protocol ChatGraphQLServicing {
    func sendMessage(
        channelId: String,
        siteId: String,
        graphqlPubApiKey: String,
        messageText: String,
        photoUrl: String?,
        mediaUrl: String?,
        displayName: String?,
        userId: String,
        token: String?,
        isGif: Bool,
        completion: @escaping (Result<Message, ServiceError>) -> Void
    )

    func replyMessage(
        channelId: String,
        siteId: String,
        graphqlPubApiKey: String,
        messageText: String,
        photoUrl: String?,
        mediaUrl: String?,
        displayName: String?,
        userId: String,
        replyId: String,
        token: String?,
        isGif: Bool,
        completion: @escaping (Result<Message, ServiceError>) -> Void
    )
}

struct ChatGraphQLService {

    private let client: ApolloClientable
    private let interceptor: HeaderAddingInterceptor

    private let xAPIKey = "x-api-key"
    private let arToken = "ar-token"
    private let arSiteID = "ar-site-id"

    init(client: ApolloClientable, interceptor: HeaderAddingInterceptor) {
        self.client = client
        self.interceptor = interceptor
    }
}

extension ChatGraphQLService: ChatGraphQLServicing {
    func sendMessage(
        channelId: String,
        siteId: String,
        graphqlPubApiKey: String,
        messageText: String,
        photoUrl: String?,
        mediaUrl: String?,
        displayName: String?,
        userId: String,
        token: String?,
        isGif: Bool,
        completion: @escaping (Result<Message, ServiceError>) -> Void
    ) {
        let factory = ChatOperationFactory.sendMessage(channelId: channelId,
                                                       messageText: messageText,
                                                       mediaUrl: mediaUrl,
                                                       displayName: displayName,
                                                       userId: userId,
                                                       isGif: isGif)
        interceptor.headers = [
            xAPIKey: graphqlPubApiKey,
            arToken: token ?? "",
            arSiteID: siteId
        ]

        client.perform(mutation: factory.operation) { result in
            switch result {
            case let .success(graphQLResult):
                if let errors = graphQLResult.errors {
                    let errorDescriptions = errors.reduce("", { partialResult, error in
                        partialResult + "\n" + (error.errorDescription ?? "")
                    })

                    completion(.failure(.graphQLError(errorDescriptions)))
                    return
                }

                let message = Message(createdAt: Date().timeIntervalSince1970,
                                      key: graphQLResult.data?.sendMessage,
                                      content: MessageContent(text: messageText,
                                                              media: MessageContentMedia(thumbnailUrl: mediaUrl)),
                                      changeType: "sender")
                completion(.success(message))
            case let .failure(error):
                completion(.failure(.graphQLError(error.localizedDescription)))
            }
        }

    }

    func replyMessage(
        channelId: String,
        siteId: String,
        graphqlPubApiKey: String,
        messageText: String,
        photoUrl: String?,
        mediaUrl: String?,
        displayName: String?,
        userId: String,
        replyId: String,
        token: String?,
        isGif: Bool,
        completion: @escaping (Result<Message, ServiceError>) -> Void
    ) {
        let factory = ChatOperationFactory.replyMessage(channelId: channelId,
                                                        messageText: messageText,
                                                        mediaUrl: mediaUrl,
                                                        displayName: displayName,
                                                        userId: userId,
                                                        replyId: replyId,
                                                        isGif: isGif)
        interceptor.headers = [
            xAPIKey: graphqlPubApiKey,
            arToken: token ?? "",
            arSiteID: siteId
        ]

        client.perform(mutation: factory.operation) { result in
            switch result {
            case let .success(graphQLResult):
                let message = Message(createdAt: Date().timeIntervalSince1970,
                                      key: graphQLResult.data?.sendMessage,
                                      content: MessageContent(text: messageText,
                                                              media: MessageContentMedia(thumbnailUrl: mediaUrl)),
                                      changeType: "sender")
                completion(.success(message))
            case let .failure(error):
                completion(.failure(.graphQLError(error.localizedDescription)))
            }
        }

    }
}
