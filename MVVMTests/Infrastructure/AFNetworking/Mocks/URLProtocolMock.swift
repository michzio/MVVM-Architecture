//
//  URLProtocolMock.swift
//  MVVMTests
//
//  Created by Michal Ziobro on 21/09/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation

final class URLProtocolMock : URLProtocol {
    
    enum ResponseType {
        case error(Error)
        case success(HTTPURLResponse)
        case data(HTTPURLResponse, Data)
    }
    static var responseType: ResponseType!
    
    private(set) var activeTask: URLSessionTask?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override class func requestIsCacheEquivalent(_ a: URLRequest, to b: URLRequest) -> Bool {
        return false
    }
    
    private lazy var session: URLSession = {
        let config : URLSessionConfiguration = .ephemeral
        return URLSession(configuration: config, delegate: self, delegateQueue: nil)
    }()
    
    override func startLoading() {
        activeTask = session.dataTask(with: request.urlRequest!)
        activeTask?.cancel() // we don't want to make a network call
    }
    
    override func stopLoading() {
        activeTask?.cancel()
    }
}

extension URLProtocolMock : URLSessionDataDelegate {
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        client?.urlProtocol(self, didLoad: data)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
       
        switch URLProtocolMock.responseType {
        case .error(let error)?:
            client?.urlProtocol(self, didFailWithError: error)
        case .success(let response)?:
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        case .data(let response, let data)?:
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        default:
            break
        }
        
        client?.urlProtocolDidFinishLoading(self)
    }
}

extension URLProtocolMock {
    
    enum MockError: Error {
        case none
    }
    
    static func responseWithFailure() {
        URLProtocolMock.responseType = URLProtocolMock.ResponseType.error(MockError.none)
    }
    
    static func responseWithStatusCode(code: Int) {
        URLProtocolMock.responseType = URLProtocolMock.ResponseType.success(HTTPURLResponse(url: URL(string: "http://any.com")!, statusCode: code, httpVersion: "1.1", headerFields: nil)!)
    }
    
    static func responseWithData(code: Int, data: Data) {
        let response = HTTPURLResponse(url: URL(string: "http://any.com")!, statusCode: code, httpVersion: "1.1", headerFields: nil)!
        URLProtocolMock.responseType = URLProtocolMock.ResponseType.data(response, data)
    }
}
