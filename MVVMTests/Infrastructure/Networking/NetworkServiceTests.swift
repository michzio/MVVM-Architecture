//
//  NetworkServiceTests.swift
//  MVVMTests
//
//  Created by Michal Ziobro on 20/09/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import XCTest
@testable import MVVM

class NetworkServiceTests: XCTestCase {
    
    private struct EndpointMock : Requestable, Encoder {
        
        var path: String
        var isFullPath: Bool = false
        var method: HTTPMethod
        var queryParams: [String : Any] = [:]
        var headerParams: [String : String] = [:]
        var bodyParams: [String : Any] = [:]
        var bodyEncoding: EncodingType = .stringAscii
        
        init(path: String, method: HTTPMethod) {
            self.path = path
            self.method = method
        }
    }
    
    private struct MockObject: Decodable {
        let name: String
    }

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_whenMockDataPassed_shouldReturnProperResponse() {
        
        // given
        let config = NetworkConfigurationMock()
        let data = "Response data".data(using: .utf8)
        let session = NetworkSessionMock(data: data, response: nil, error: nil)
        let sut = NetworkService(session: session, configuration: config)
        
        let expectation = self.expectation(description: "Should get valida data.")
        
        // when
        let endpoint = EndpointMock(path: "http://mock.com", method: .get)
        _ = sut.request(with: endpoint) { result in
                
            guard let responseData = try? result.get() else {
                XCTFail("Should get valid data.")
                return
            }
            XCTAssertEqual(responseData, data)
            expectation.fulfill()
        }
        
        // then
        wait(for: [expectation], timeout: 0.1)
    }

    func test_whenError_shouldReturnError() {
        
        // given
        let config = NetworkConfigurationMock()
        let error = NSError(domain: "network", code: NSURLErrorCancelled, userInfo: nil)
        let response = HTTPURLResponse(url: URL(string: "http://mock.com")!, statusCode: 200, httpVersion: "1.1", headerFields: [:])
        let session = NetworkSessionMock(data: nil, response: response, error: error)
        let sut = NetworkService(session: session, configuration: config)
        
        let expectation = self.expectation(description: "Should get url error.")
        
        // when
        let endpoint = EndpointMock(path: "http://mock.com", method: .get)
        _ = sut.request(with: endpoint) { result in
            
            do {
                _ = try result.get()
                XCTFail("Should not get data.")
            } catch let error {
                guard (error as NSError).code == NSURLErrorCancelled else {
                    XCTFail("Shoudl return URL Error Cancelled")
                    return
                }
                
                expectation.fulfill()
            }
        }
        
        // then
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_whenMalformedUrl_shouldReturnRequestableErrorUrl() {
        
        // given
        let config = NetworkConfigurationMock()
        let data = "Response data".data(using: .utf8)
        let session = NetworkSessionMock(data: data, response: nil, error: nil)
        let sut = NetworkService(session: session, configuration: config)
        
        let expectation = self.expectation(description: "Should return requestable error.")
        
        // when
        var endpoint = EndpointMock(path: "-;@,?:ą", method: .get)
        endpoint.isFullPath = true
        _ = sut.request(with: endpoint) { result in
            
            do {
                _ = try result.get()
                XCTFail("Should throw url error.")
            } catch let error {
                guard case RequestableError.url = error else {
                    XCTFail("Should throw url error.")
                    return
                }
                
                expectation.fulfill()
            }
        }
        
        // then
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_whenStatusCodeEqualOrAbove400_shouldReturnError() {
        
        // given
        let config = NetworkConfigurationMock()
        let response = HTTPURLResponse(url: URL(string: "http://mock.com")!, statusCode: 500, httpVersion: "1.1", headerFields: [:])
        let session = NetworkSessionMock(data: nil, response: response, error: nil)
        let sut = NetworkService(session: session, configuration: config)
        
        let expectation = self.expectation(description: "Should return error when status code >= 400")
        
        // when
        let endpoint = EndpointMock(path: "test", method: .get)
        _ = sut.request(with: endpoint) { result in
            
            do {
                _ = try result.get()
                XCTFail("Should not get response data.")
            } catch let error {
                if case NetworkError.statusCode(let code) = error {
                    XCTAssertEqual(code, 500)
                    expectation.fulfill()
                }
            }
        }
        
        // then
            wait(for: [expectation], timeout: 0.1)
    }
    
    func test_whenJSON_shouldDecodeUsingDecodable() {
        
        // given
        let config = NetworkConfigurationMock()
        let data = #"{"name": "Hello"}"#.data(using: .utf8)
        let session = NetworkSessionMock(data: data, response: nil, error: nil)
        let sut = NetworkService(session: session, configuration: config)
        
        let expactation = self.expectation(description: "Should decode mock decodable object")
        
        // when
        let endpoint = EndpointMock(path: "http://mock.com", method: .get)
        _ = sut.request(with: endpoint) { (result : Result<MockObject, Error>) -> Void in
            
            do {
                let object = try result.get()
                XCTAssertEqual(object.name, "Hello")
                expactation.fulfill()
            } catch {
                XCTFail("Mock Object decoding failed.")
            }
        }
        
        // then
        wait(for: [expactation], timeout: 0.1)
    }
    
    func test_whenInvalidJSON_shouldNotDecodeUsingDecodable() {
        
        // given
        let config = NetworkConfigurationMock()
        let data = #"{"age": 18}"#.data(using: .utf8)
        let session = NetworkSessionMock(data: data, response: nil, error: nil)
        let sut = NetworkService(session: session, configuration: config)
        
        let expactation = self.expectation(description: "Should not decode invalid object")
        
        // when
        let endpoint = EndpointMock(path: "http://mock.com", method: .get)
        _ = sut.request(with: endpoint) { (result : Result<MockObject, Error>) -> Void in
            
            do {
                _ = try result.get()
                XCTFail("Should not decode this object.")
            } catch {
                expactation.fulfill()
            }
        }
        
        // then
        wait(for: [expactation], timeout: 0.1)
    }
    
    func test_whenNoDataReceived_shouldThrowNetworkErrorEmpty() {
        
        // given
        let config = NetworkConfigurationMock()
        let response = HTTPURLResponse(url: URL(string: "http://mock.com")!, statusCode: 200, httpVersion: "1.1", headerFields: [:])
        let session = NetworkSessionMock(data: nil, response: response, error: nil)
        let sut = NetworkService(session: session, configuration: config)
        
        let expactation = self.expectation(description: "Should throw network error empty")
        
        // when
        let endpoint = EndpointMock(path: "http://mock.com", method: .get)
        _ = sut.request(with: endpoint) { (result : Result<MockObject, Error>) -> Void in
            
            do {
                _ = try result.get()
                XCTFail("Should not get data.")
            } catch let error {
                if case NetworkError.empty = error {
                    expactation.fulfill()
                } else {
                    XCTFail("Wrong error")
                }
            }
        }
        
        // then
        wait(for: [expactation], timeout: 0.1)
    }
}


