import Apollo
import Foundation

final class HeaderAddingInterceptor: ApolloInterceptor {

    var headers: [String: String] = [:]

    func interceptAsync<Operation: GraphQLOperation>(
        chain: RequestChain,
        request: HTTPRequest<Operation>,
        response: HTTPResponse<Operation>?,
        completion: @escaping (Result<GraphQLResult<Operation.Data>, Error>) -> Void
    ) {
        headers.forEach { key, value in
            request.addHeader(name: key, value: value)
        }

        chain.proceedAsync(request: request,
                           response: response,
                           completion: completion)
    }
}
