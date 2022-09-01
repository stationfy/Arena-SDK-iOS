import Foundation

public protocol ClientRequestable {
    /// Creates a `URLSessionDataTaskCancelable` by setuping and making a request to the endpoint setted.
    ///
    /// - Parameters:
    ///   - setup: `EndpointSetuping` endpoint configuration to create a request.
    ///   - completion: `(Result<T, ServiceError>) -> ()` closusre with threated request response, it can be
    ///   the Decodable object parsed on success of the response or any of ServiceError case.
    ///
    /// - Returns:     A request cancelable`URLSessionDataTaskCancelable`, this result is discardable .
    @discardableResult
    func request<T: Decodable>(setup: EndpointSetuping,
                               completion: @escaping (Result<T, ServiceError>) -> Void
    ) -> URLSessionDataTaskCancelable?
}

final public class HTTPClient {
    private var baseUrl: String
    private let successResponse: String = "success"
    private let sessionManager: SessionClearable
    private let urlSession: URLSessionTaskable
    private let logger: Logging

    private var decoder: JSONDecoder = {
        let deconder = JSONDecoder()
        deconder.keyDecodingStrategy = .convertFromSnakeCase
        return deconder
    }()

    public init(baseUrl: String,
                sessionManager: SessionClearable,
                logger: Logging,
                urlSession: URLSessionTaskable = URLSession.shared) {
        self.baseUrl = baseUrl
        self.sessionManager = sessionManager
        self.urlSession = urlSession
        self.logger = logger
    }

    private func handleError(error: Error) -> ServiceError {
        let nsError: NSError = error as NSError

        switch nsError.code {
        case NSURLErrorNotConnectedToInternet:
            return .notConnectedToInternet(error.localizedDescription)
        default:
            return .unknown(error.localizedDescription)
        }
    }

    private func handleStatusError(code: Int, data: Data) -> ServiceError? {
        switch code {
        case 200...299:
            return nil
        case 401:
            sessionManager.clear()
            return .authenticationRequired
        case 404:
            return .hostNotFound
        case 409:
            return .alreadyExist
        case 500:
            return .badRequest
        default:
            guard !data.isEmpty else { return .emptyData }
            return decodeFailure(data: data)
        }
    }

    private func decodeSuccess<T: Decodable>(data: Data) -> Result<T, ServiceError> {
        do {
            let item = try data.parse() as T
            return .success(item)
        } catch let error {
            self.logger.log(object: error.localizedDescription, event: .error)
            return .failure(.responseEncondingFailure(error.localizedDescription))
        }
    }

    private func decodeFailure(data: Data) -> ServiceError {
        do {
            let item: FailureResponse = try data.parse()
            return .requestFailure(item)
        } catch let error {
            return .unknown(error.localizedDescription)
        }
    }

    private func logRequest(description: String) {
        logger.log(object: "REQUEST")
        logger.log(object: description)
    }

    private func logResponse(description: String, data: Data?) {
        self.logger.log(object: "RESPONSE")
        self.logger.log(object: description)
        self.logger.log(object: "\(String(data: data ?? Data(), encoding: .utf8) ?? "")")
    }
}

extension HTTPClient: ClientRequestable {

    @discardableResult
    public func request<T: Decodable>(setup: EndpointSetuping,
                                      completion: @escaping (Result<T, ServiceError>) -> Void
    ) -> URLSessionDataTaskCancelable? {
        let request: URLRequest
        do {
            request = try URLRequest(baseUrl: baseUrl, sessionManager: sessionManager, setup: setup)
            logRequest(description: request.description)
        } catch let error as ServiceError {
            completion(.failure(error))
            logger.log(object: error.localizedDescription, event: .error)
            return nil
        } catch let error {
            completion(.failure(.unknown(error.localizedDescription)))
            logger.log(object: error.localizedDescription, event: .error)
            return nil
        }

        let task = urlSession.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            self.logResponse(description: response?.description ?? "", data: data)

            if let error = error {
                self.logger.log(object: error.localizedDescription, event: .error)
                completion(.failure(self.handleError(error: error)))
                return
            }

            guard let urlResponse = response as? HTTPURLResponse else {
                self.logger.log(object: ServiceError.invalidHttpUrlResponse.localizedDescription, event: .error)
                completion(.failure(.invalidHttpUrlResponse))
                return
            }

            guard let data = data else {
                self.logger.log(object: ServiceError.brokenData(urlResponse.statusCode).localizedDescription, event: .error)
                completion(.failure(.brokenData(urlResponse.statusCode)))
                return
            }

            if let error = self.handleStatusError(code: urlResponse.statusCode, data: data) {
                self.logger.log(object: error.localizedDescription, event: .error)
                completion(.failure(error))
                return
            }

            if data.isEmpty {
                guard let success = SuccessResponse(response: self.successResponse) as? T else {
                    completion(.failure(.emptyData))
                    return
                }

                completion(.success(success))
                return
            }
            return completion(self.decodeSuccess(data: data))
        }

        task.resume()
        return task
    }

}
