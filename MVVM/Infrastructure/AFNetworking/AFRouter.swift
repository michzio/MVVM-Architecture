//
//  AFRouter.swift
//  MVVM
//
//  Created by Michal Ziobro on 17/09/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation
import Alamofire

protocol AFRouter : Requestable, Encoder, URLRequestConvertible {
    var baseURL : String { get }
}

// MARK: - Requestable
extension AFRouter {
    
    public func urlRequest(with config: INetworkConfiguration) throws -> URLRequest {
        
        /* option: reusing Requestable
            let config = NetworkConfiguaration(baseURL: URL(string: AFRouter.baseURL)!)
            return try self.urlRequest(with: config)
         */
        
        var urlRequest = try asURLRequest()
        
        config.headers.forEach { (key, value) in
            urlRequest.addValue(value, forHTTPHeaderField: key)
        }
        urlRequest.url = urlRequest.url?.appendQueryParams(params: config.queryParams)
        
        return urlRequest
    }
}


// MARK: - URLRequestConvertible
extension AFRouter {
    
    public func asURLRequest() throws -> URLRequest {
        
        var baseUrlString = self.baseURL
        baseUrlString += (baseUrlString.last != "/") ? "/" : ""
        
        let urlString = isFullPath ? path : baseUrlString.appending(path)
        let url = try urlString.asURL()
        
        var urlRequest = URLRequest(url: url)
        
        // HTTP Method
        urlRequest.httpMethod = method.rawValue
        
        // Header Params
        var headers = [String:String]()
        headerParams.forEach { headers.updateValue($0.value, forKey: $0.key) }
        urlRequest.allHTTPHeaderFields = headers
        
        // Body Params
        if !bodyParams.isEmpty {
            urlRequest.httpBody = encoded(bodyParams, encoding: bodyEncoding)
            // urlRequest = try URLEncoding.httpBody.encode(urlRequest, with: bodyParams)
        }
        
        // Query Params
        urlRequest = try URLEncoding.queryString.encode(urlRequest, with: queryParams)
        
        return urlRequest
    }
}
