import Foundation

public protocol URLSessionTaskable {
    func dataTask(with request: URLRequest,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTask
}

extension URLSession: URLSessionTaskable { }

public protocol URLSessionDataTaskCancelable {
    func cancel()
}

extension URLSessionDataTask: URLSessionDataTaskCancelable { }

extension URL {
    init(baseUrl: String, path: String) throws {
        guard var components = URLComponents(string: baseUrl) else {
            throw ServiceError.invalidBaseUrl
        }

        components.path += path

        guard let url = components.url else {
            throw ServiceError.invalidUrl
        }

        self = url
    }
}

extension URLRequest {
    init(baseUrl: String, sessionManager: SessionClearable, setup: EndpointSetuping) throws {
        let path = setup.version.rawValue + setup.path.rawValue + setup.endpoint
        let url = try URL(baseUrl: baseUrl, path: path)
        let urlRequest = URLRequest(url: url)
        let encoding = URLRequest.encoding(method: setup.method)
        self = try encoding.encode(urlRequest, with: setup.parameters)
        httpMethod = setup.method.rawValue
        setup.header.forEach { key, value in
            addValue(value, forHTTPHeaderField: key)
        }

        if let accessToken = sessionManager.accessToken,
           setup.isAuthenticated {
            HTTPHeader.authorization(accessToken).forEach { key, value in
                addValue(value, forHTTPHeaderField: key)
            }
        }
    }

    private static func encoding(method: HTTPMethod) -> ParameterEncoding {
        switch method {
        case .get:
            return URLEncoder.default
        default:
            return JSONEncoder.default
        }
    }

    var description: String {
        var textDescription = ""

        if let headers = allHTTPHeaderFields,
           !headers.isEmpty {
            textDescription += "HEADERS: \(String(describing: headers))\n"
        }

        textDescription += "URL: [\(httpMethod ?? "")] \(url?.absoluteString ?? "")\n"

        if let httpBody = httpBody {
            let body = String(data: httpBody, encoding: .utf8) ?? ""
            textDescription += "BODY: \(body)\n"
        }

        return textDescription
    }
}
