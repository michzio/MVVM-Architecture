//
//  NetworkLogger.swift
//  MVVM
//
//  Created by Michal Ziobro on 16/09/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation

protocol INetworkLogger {
    func log(request: URLRequest)
    func log(response: URLResponse?, data: Data?)
    func log(error: Error)
    func log(statusCode: Int)
}

final public class NetworkLogger : INetworkLogger {
    
    public init() { }
    
    public func log(request: URLRequest) {
        #if DEBUG
        print("------------------------")
        print("request: \(request.url!)")
        print("headers: \(request.allHTTPHeaderFields!)")
        print("method: \(request.httpMethod!)")
        if let httpBody = request.httpBody,
            let result = (try? JSONSerialization.jsonObject(with: httpBody, options: []) as? [String: AnyObject]) {
            print("body: \(String(describing: result))")
        }
        if let httpBody = request.httpBody, let resultString = String(data: httpBody, encoding: .utf8) {
            print("body: \(String(describing: resultString))")
        }
        #endif
    }
    
    public func log(response: URLResponse?, data: Data?) {
        #if DEBUG
        guard let data = data else { return }
        if let dict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            print("response: \(String(describing: dict))")
        }
        #endif
    }
    
    public func log(error: Error) {
        #if DEBUG
        print("error: \(error)")
        #endif
    }
    
    public func log(statusCode: Int) {
        #if DEBUG
        print("statusCode: \(statusCode)")
        #endif
    }
}
