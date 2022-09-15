// Mezhevikin Alexey: https://github.com/mezhevikin/http-request

import Foundation

public func HttpRequest(
    url: String,
    method: HttpMethod = .get,
    parameters: [String: Any] = [:],
    headers: [String: String] = [:]
) -> URLRequest {
    let url = method == .get && !parameters.isEmpty ?
        url + "?" + parameters.query : url
    var request = URLRequest(url: URL(string: url)!)
    request.httpMethod = "\(method)".uppercased()
    request.allHTTPHeaderFields = headers
    if method == .post && !parameters.isEmpty {
        request.httpBody = parameters.query.data(using: .utf8)
    }
    return request
}

public enum HttpMethod: String {
    case get, post, head, put, delete
}

extension URLRequest {
    public func data(completion: @escaping ((HttpResponse) -> Void)) {
        URLSession.shared.dataTask(with: self) { data, original, error in
            let response = HttpResponse()
            response.original = original as! HTTPURLResponse?
            response.data = data
            response.error = error
            completion(response)
        }.resume()
    }
    
    public func json<T>(
        _ type: T.Type,
        completion: @escaping ((T?, HttpResponse) -> Void)
    ) -> Void where T : Decodable {
        data { response in
            var json: T? = nil
            if let data = response.data {
                do {
                    json = try JSONDecoder().decode(T.self, from: data)
                } catch {
                    response.error = error
                }
            }
            DispatchQueue.main.async {
                completion(json, response)
            }
        }
    }
}

open class HttpResponse {
    public var original: HTTPURLResponse?
    public var data: Data?
    public var error: Error?
    public var success: Bool {
        error == nil && original != nil && 200 ..< 300 ~= original!.statusCode
    }
}

extension Dictionary {
    var query: String {
        map() { key, value -> String in
            "\(key)=\("\(value)".urlEncoded)"
        }.joined(separator: "&")
    }
}

extension String {
    var urlEncoded: String {
        addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics)!
    }
}
