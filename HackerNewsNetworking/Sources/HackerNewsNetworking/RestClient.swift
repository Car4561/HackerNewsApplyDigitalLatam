//
//  RestClient.swift
//  
//
//  Created by Carlos Llerena on 1/12/24.
//

import Combine
import Foundation

public typealias JSON = [String: Any]

open class RestClient: NSObject, @unchecked Sendable {
    
    private let baseURL: String
    private let headers: HTTPHeaders
    
    public init(configuration: ClientConfiguration) {
        baseURL = configuration.baseURL
        headers = configuration.httpHeaders
    }
    
    public func request<T: Decodable & Sendable, U :Decodable & Sendable>(resource: Resource,
                                                    parameters: JSON? = nil,
                                                    type: T.Type,
                                                    errorType: U.Type) -> AnyPublisher<T, NetworkingError> {
        let fullURLString = baseURL + resource.resource.route
        
        guard let url = URL(string: fullURLString) else {
            return Fail(error: NetworkingError.invalidRequestError("Invalid URL: \(fullURLString)")).eraseToAnyPublisher()
        }
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = resource.resource.method.rawValue
        
        headers.forEach { (key, value) in
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        
        if resource.resource.method != .get,
           let parameters = parameters {
            urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        }
        
        let session = URLSession(configuration: URLSessionConfiguration.default,
                                 delegate: self,
                                 delegateQueue: nil)
        
        return session.dataTaskPublisher(for: urlRequest)
            .mapError({ error -> NetworkingError in
                if error.code  == URLError.Code.notConnectedToInternet {
                    return .notConnectionInternet(error)
                }
                return .unexpectedError(error)
            })
            .tryMap({ (data, response) -> (data: Data, response: URLResponse) in
                guard let urlResponse = response as? HTTPURLResponse else {
                    throw NetworkingError.invalidResponse
                }
                
                switch urlResponse.statusCode {
                case 401:
                    throw NetworkingError.unauthorized
                case 400, 402...599:
                    let decoder = JSONDecoder()
                    let apiError = try decoder.decode(errorType, from: data)
                    
                    throw NetworkingError.apiError(error: apiError)
                default:
                    break
                }
                
                return (data, response)
            })
            .map(\.data)
            .tryMap({ data -> T in
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                do {
                    return try decoder.decode(T.self, from: data)
                } catch let DecodingError.keyNotFound(key, context) {
                    let message = """
                    Key not found: \(key.stringValue)
                    CodingPath: \(context.codingPath.map(\.stringValue).joined(separator: " -> "))
                    DebugDescription: \(context.debugDescription)
                    """
                    print(message)
                    throw NetworkingError.invalidResponse
                } catch let DecodingError.typeMismatch(type, context) {
                    let message = """
                    Type mismatch for key: \(context.codingPath.map(\.stringValue).joined(separator: " -> "))
                    Expected type: \(type)
                    DebugDescription: \(context.debugDescription)
                    """
                    print(message)
                    throw NetworkingError.invalidResponse
                } catch let DecodingError.valueNotFound(value, context) {
                    let message = """
                    Value not found: \(value)
                    CodingPath: \(context.codingPath.map(\.stringValue).joined(separator: " -> "))
                    DebugDescription: \(context.debugDescription)
                    """
                    print(message)
                    throw NetworkingError.invalidResponse
                } catch let DecodingError.dataCorrupted(context) {
                    let message = """
                    Data corrupted at: \(context.codingPath.map(\.stringValue).joined(separator: " -> "))
                    DebugDescription: \(context.debugDescription)
                    """
                    print(message)
                    throw NetworkingError.invalidResponse
                } catch {
                    let message = "Unknown decoding error: \(error.localizedDescription)"
                    print(message)
                    throw NetworkingError.invalidResponse
                }
            })

            .mapError({ error in
                guard let networkingError = error as? NetworkingError else { return .unexpectedError(error) }
                return networkingError
            })
            .eraseToAnyPublisher()
    }
    
}


extension RestClient: URLSessionDelegate
{

    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        guard let serverTrust = challenge.protectionSpace.serverTrust else {
            return completionHandler(URLSession.AuthChallengeDisposition.useCredential, nil)
        }
        return completionHandler(URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust: serverTrust))
        
    }

}
