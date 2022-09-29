import Foundation

typealias Parameters = [String: Any]

/// A type used to define how a set of parameters are applied to a `URLRequest`.
protocol ParameterEncoding {
    /// Creates a `URLRequest` by encoding parameters and applying them on the passed request.
    ///
    /// - Parameters:
    ///   - urlRequest: `URLRequest` value onto which parameters will be encoded.
    ///   - parameters: `Parameters` to encode onto the request.
    ///
    /// - Returns:      The encoded `URLRequest`.
    /// - Throws:       Any `Error` produced during parameter encoding.
    func encode(_ urlRequest: URLRequest, with parameters: Parameters?) throws -> URLRequest
}

struct URLParameterEncoder: ParameterEncoding {

    /// Returns a `URLEncoder` instance with default writing options.
    static var `default`: URLParameterEncoder { URLParameterEncoder() }

    private init() { }

    func encode(_ urlRequest: URLRequest, with parameters: Parameters?) throws -> URLRequest {
        guard let parameters = parameters else { return urlRequest }

        var mutableUrlRequest = urlRequest
        guard let url = urlRequest.url else {
            throw ServiceError.parameterUrlEncodingNotFound
        }

        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !parameters.isEmpty {
            var queryItems = urlComponents.queryItems ?? []
            queryItems.append(contentsOf: query(parameters))
            urlComponents.queryItems = queryItems
            mutableUrlRequest.url = urlComponents.url
        }
        return mutableUrlRequest
    }

    /// Creates a percent-escaped, URL encoded query string components from the given key-value pair recursively.
    ///
    /// - Parameters:
    ///   - key:   Key of the query component.
    ///   - value: Value of the query component.
    ///
    /// - Returns: The percent-escaped, URL encoded URLQueryItem.
    private func getQueryItems(fromKey key: String, value: Any) -> [URLQueryItem] {
        var queryItem: [URLQueryItem] = []
        switch value {
        case let dictionary as [String: Any]:
            for (nestedKey, value) in dictionary {
                queryItem.append(contentsOf: getQueryItems(fromKey: nestedKey, value: value))
            }
        case let array as [Any]:
            for value in array {
                queryItem.append(contentsOf: getQueryItems(fromKey: key, value: value))
            }
        case let bool as Bool:
            queryItem.append(URLQueryItem(name: escape(key), value: escape(escape(bool ? "true" : "false"))))
        case let number as NSNumber:
            queryItem.append(URLQueryItem(name: escape(key), value: escape("\(number)")))
        default:
            queryItem.append(URLQueryItem(name: escape(key), value: escape("\(value)")))
        }
        return queryItem
    }

    /// Creates a percent-escaped string following .urlQueryAllowed for a query string key or value.
    ///
    /// - Parameter string: `String` to be percent-escaped.
    ///
    /// - Returns:          The percent-escaped `String`.
    private func escape(_ string: String) -> String {
        string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? string
    }

    private func query(_ parameters: [String: Any]) -> [URLQueryItem] {
        var queryItem: [URLQueryItem] = []

        for key in parameters.keys.sorted(by: <) {
            guard let value = parameters[key] else { continue }
            queryItem.append(contentsOf: getQueryItems(fromKey: key, value: value))
        }
        return queryItem
    }
}

/// Uses `JSONSerialization` to create a JSON representation of the parameters object, which is set as the body of the
/// request. The `Content-Type` HTTP header field of an encoded request is set to `application/json`.
struct JSONParameterEncoder: ParameterEncoding {

    // MARK: Properties

    /// Returns a `JSONEncoder` instance with default writing options.
    static var `default`: JSONParameterEncoder { JSONParameterEncoder() }

    private init() { }

    // MARK: Encoding

    func encode(_ urlRequest: URLRequest, with parameters: Parameters?) throws -> URLRequest {
        var mutableUrlRequest = urlRequest

        guard let parameters = parameters else { return urlRequest }

        do {
            let data = try JSONSerialization.data(withJSONObject: parameters, options: [])

            if mutableUrlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                mutableUrlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            }

            mutableUrlRequest.httpBody = data
        } catch let error {
            throw ServiceError.parameterJsonEncodingFailure(error.localizedDescription)
        }
        return mutableUrlRequest
    }
}
