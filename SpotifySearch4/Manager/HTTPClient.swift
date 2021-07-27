//
//  httpClient.swift
//  SpotifySearch4
//
//  Created by Mateo Riofrio on 7/26/21.
//

import Foundation

protocol URLSessionProtocol { typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void
    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol
}
protocol URLSessionDataTaskProtocol { func resume() }

extension URLSession: URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
            return (dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTask)
                as URLSessionDataTaskProtocol
        }
}
extension URLSessionDataTask: URLSessionDataTaskProtocol {}

/**
 * A client for get and post http requests that requires a URLSession, this allows to inject mock session for testing.
 *
 * - Parameters:
 *   - session: session that follows URLSessionProtocol
 */
final class HTTPClient {
    typealias completeClosure = ( _ data: Data?, _ error: Error?) -> Void
    private let session: URLSessionProtocol
    private var debug = false
    init(session: URLSessionProtocol) {
        self.session = session
    }
    
    func get( url: String, params: [String: String] = [:], headers: [String: String] = [:], callback: @escaping completeClosure ) {
        // create url with query added to passed url
        var components = URLComponents(string: url)!
        if params.isEmpty == false {
            components.queryItems = params.map{ (key, value) in
                URLQueryItem(name: key, value: value)
            }
        }
        // create request with new url and set headers
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        if headers != [:] { request.allHTTPHeaderFields = headers }
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if (self.debug) {
                if let status = response as? HTTPURLResponse {
                    print("GET request:", status.statusCode)
                }
            }
            callback(data, error)
            
        }
        task.resume()
    }
    
    func post( url: String, params: [String: String] = [:], headers: [String: String] = [:], callback: @escaping completeClosure ) {
        var components = URLComponents()
        components.queryItems = params.map { (key, value) in
            URLQueryItem(name: key, value: value)
        }
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "POST"
        request.httpBody = components.query?.data(using: .utf8)
        request.allHTTPHeaderFields = headers
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if (self.debug) {
                if let status = response as? HTTPURLResponse {
                    print("POST request:", status.statusCode)
                    let str = String(decoding: data!, as: UTF8.self)
                    print(str)
                }
            }
            callback(data, error)
        }
        task.resume()
    }
}
