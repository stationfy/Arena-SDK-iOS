import Foundation
import Apollo

class NetworkInterceptorProvider: DefaultInterceptorProvider {

    let interceptor: HeaderAddingInterceptor

    init(client: URLSessionClient, store: ApolloStore, interceptor: HeaderAddingInterceptor) {
        self.interceptor = interceptor
        super.init(client: client, store: store)
    }

    override func interceptors<Operation: GraphQLOperation>(for operation: Operation) -> [ApolloInterceptor] {
        var interceptors = super.interceptors(for: operation)
        interceptors.insert(interceptor, at: 0)
        return interceptors
    }
}
