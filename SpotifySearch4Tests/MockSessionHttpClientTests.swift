//
//  HttpClientTests.swift
//  SpotifySearch4Tests
//
//  Created by Mateo Riofrio on 7/26/21.
//

import XCTest
import UIKit
@testable import SpotifySearch4

class MockURLSession: URLSessionProtocol {
    private (set) var lastURL: URL?
    private (set) var lastHeaders: [String: String]?
    
    var nextDataTask = MockURLSessionDataTask()
    var nextData: Data?
    var nextError: Error?
    
    func successHttpURLResponse(request: URLRequest) -> URLResponse {
        return HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)!
    }
    
    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
        lastURL = request.url
        lastHeaders = request.allHTTPHeaderFields
        completionHandler(nextData, successHttpURLResponse(request: request), nextError)
        return nextDataTask
    }
}

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    private (set) var resumeWasCalled = false
    func resume() {
        resumeWasCalled = true
    }
}


class MockSessionHttpClientTests: XCTestCase {
    
    var httpClient: HTTPClient!
    let session = MockURLSession()
    
    override func setUp() {
        super.setUp()
        httpClient = HTTPClient(session: session)
    }
    override func tearDown() {
        super.tearDown()
    }
    
    func testHttpClient_URLPassed_MatchesSessionUrl() {
        let url = "http://mockurl"
        httpClient.get(url: "http://mockurl") { data, error in }
        
        XCTAssertEqual(session.lastURL, URL(string: url))
    }
    
    func testHttpClient_HeadersPassed_MatchRequestHeaders() {
        let url = "http://mockurl"
        let headers: [String : String] = [
            "Accept": "application/json",
            "Content-Type": "application/json",
        ]
        httpClient.post(url: url, headers: headers) { data, error in }
        
        XCTAssertEqual(session.lastHeaders, headers)
    }
    func testHttpClient_GetMethod_MatchesData() {
        let expectedData = "{}".data(using: .utf8)
                
        session.nextData = expectedData
        
        var actualData: Data?
        httpClient.get(url: "http://mockurl") { (data, error) in
            actualData = data
        }
        
        XCTAssertNotNil(actualData)
    }
    
}
