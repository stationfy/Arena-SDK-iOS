import Foundation
import Apollo

public protocol ApolloClientable {
    @discardableResult
    func perform<Mutation: GraphQLMutation>(mutation: Mutation,
                                            resultHandler: GraphQLResultHandler<Mutation.Data>?) -> Cancellable
    @discardableResult
    func perform<Mutation: GraphQLMutation>(mutation: Mutation,
                                            publishResultToStore: Bool,
                                            queue: DispatchQueue,
                                            resultHandler: GraphQLResultHandler<Mutation.Data>?) -> Cancellable
}

extension ApolloClient: ApolloClientable {
    @discardableResult
    public func perform<Mutation>(
        mutation: Mutation,
        resultHandler: GraphQLResultHandler<Mutation.Data>?
    ) -> Cancellable where Mutation : GraphQLMutation {
        self.perform(mutation: mutation,
                     publishResultToStore: true,
                     queue: .main,
                     resultHandler: resultHandler)
    }

    static func build(interceptor: HeaderAddingInterceptor) -> ApolloClient {
        let client = URLSessionClient()
        let cache = InMemoryNormalizedCache()
        let store = ApolloStore(cache: cache)
        let provider = NetworkInterceptorProvider(client: client, store: store, interceptor: interceptor)
        let url = URL(string: "http://localhost:4000/graphql")!
        let transport = RequestChainNetworkTransport(interceptorProvider: provider,
                                                     endpointURL: url)
        return ApolloClient(networkTransport: transport, store: store)
    }
}
