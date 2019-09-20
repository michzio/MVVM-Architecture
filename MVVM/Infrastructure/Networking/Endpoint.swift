//
//  DataEndpoint.swift
//  MVVM
//
//  Created by Michal Ziobro on 16/09/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation

public enum HTTPMethod: String {
    case get = "GET"
    case head = "HEAD"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

public enum EncodingType {
    case jsonSerialization
    case stringAscii
}


public class Endpoint: Requestable, Encoder {
    
    public var path: String
    public var isFullPath: Bool = false
    public var method: HTTPMethod = .get
    public var queryParams: [String: Any] = [:]
    public var headerParams: [String: String] = [:]
    public var bodyParams: [String: Any] = [:]
    public var bodyEncoding : EncodingType = .jsonSerialization
    
    init(path: String,
         isFullPath: Bool = false,
         method: HTTPMethod = .get,
         queryParams: [String: Any] = [:],
         headerParams: [String: String] = [:],
         bodyParams: [String: Any] = [:],
         bodyEncoding: EncodingType = .jsonSerialization) {
        
        self.path = path
        self.isFullPath = isFullPath
        self.method = method
        self.queryParams = queryParams
        self.headerParams = headerParams
        self.bodyParams = bodyParams
        self.bodyEncoding = bodyEncoding
    }
}

public protocol Requestable {
    
    var path: String { get }
    var isFullPath: Bool { get }
    var method: HTTPMethod { get }
    var queryParams: [String: Any] { get }
    var headerParams: [String: String] { get }
    var bodyParams: [String: Any] { get }
    var bodyEncoding: EncodingType { get }
    
    func urlRequest(with config: INetworkConfiguration) throws -> URLRequest
}

public protocol Encoder {
    func encoded(_ params: [String:Any], encoding: EncodingType) -> Data?
}

enum RequestableError : Error {
    case url
}

extension Requestable where Self : Encoder {
    
    func url(with config: INetworkConfiguration) throws -> URL {
        
        var baseURL = config.baseURL.absoluteString
        baseURL += (baseURL.last != "/") ? "/" : ""
        
        let endpoint = isFullPath ? path : baseURL.appending(path)
    
        guard var urlComponents = URLComponents(string: endpoint) else { throw RequestableError.url }
        var urlQueryItems = [URLQueryItem]()
        
        queryParams.forEach {  urlQueryItems.append(URLQueryItem(name: $0.key, value: "\($0.value)")) }
        config.queryParams.forEach { urlQueryItems.append(URLQueryItem(name: $0.key, value: $0.value)) }
        
        urlComponents.queryItems = !urlQueryItems.isEmpty ? urlQueryItems : nil
        
        guard let url = urlComponents.url else { throw RequestableError.url }
        return url
    }
    
    public func urlRequest(with config: INetworkConfiguration) throws -> URLRequest {
        
        let url = try self.url(with: config)
        var urlRequest = URLRequest(url: url)
        
        var headers = config.headers
        headerParams.forEach { headers.updateValue($0.value, forKey: $0.key) }
        
        if !bodyParams.isEmpty {
            urlRequest.httpBody = encoded(bodyParams, encoding: bodyEncoding)
        }
        
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = headers
        
        return urlRequest
    }
}

extension Encoder {
    
    public func encoded(_ params: [String:Any], encoding: EncodingType) -> Data? {
           switch encoding {
           case .jsonSerialization:
               return try? JSONSerialization.data(withJSONObject: params)
           case .stringAscii:
               return params.queryString.data(using: String.Encoding.ascii, allowLossyConversion: true)
           }
       }
}

fileprivate extension Dictionary {
    
    var queryString: String {
        return self.map { "\($0.key)=\($0.value)" }
                .joined(separator: "&")
                .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    }
}

final public class DataEndpoint<T: Any>: Endpoint { }
