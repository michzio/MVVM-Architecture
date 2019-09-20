//
//  NetworkConfiguration.swift
//  MVVM
//
//  Created by Michal Ziobro on 16/09/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation

public protocol INetworkConfiguration {
    var baseURL: URL { get }
    var headers: [String: String] { get }
    var queryParams : [String: String] { get }
}


public struct NetworkConfiguaration: INetworkConfiguration {
    public let baseURL: URL
    public let headers: [String : String]
    public let queryParams: [String : String]
    
    public init(baseURL: URL,
                headers: [String: String] = [:],
                queryParams: [String: String] = [:]) {
        self.baseURL = baseURL
        self.headers = headers
        self.queryParams = queryParams
    }
}
