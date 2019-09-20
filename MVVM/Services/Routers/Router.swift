//
//  Router.swift
//  MVVM
//
//  Created by Michal Ziobro on 18/09/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

// This is alternative way to define endpoints (see Endpoints.swift)
// It is styled on Alamofire approach

import Foundation

// MARK: - Router
public enum Router : AFRouter {

    static let baseURL = ""
    
    case sample
    case movies(query: String, page: Int)
    case moviePoster(path: String, width: Int)
}

// MARK: - Paths
extension Router {
    
    public var path: String {
        switch self {
        case .sample:
            return "/"
        case .movies:
            return "/3/search/movie"
        case .moviePoster(let path, let width):
            let sizes = [92, 185, 500, 780]
            let availableWidth = sizes.sorted().first { width <= $0 } ?? sizes.last
            return "t/p/w\(availableWidth!)\(path)"
        }
    }
    
    public var isFullPath: Bool {
        return false
    }
}

// MARK: - HTTP methods
extension Router {
    
    public var method: HTTPMethod {
        switch self {
        default:
            return .get
        }
    }
}

// MARK: - Header Params
extension Router {
    
    public var headerParams: [String: String] {
        switch self {
        default:
            return [:]
        }
    }
}

// MARK: - Query Params
extension Router {
    
    public var queryParams: [String: Any] {
        switch self {
        default:
            return [:]
        }
    }
}

// MARK: - Body Params
extension Router {
    
    public var bodyParams: [String: Any] {
        switch self {
        default:
            return [:]
        }
    }
}

// MARK: - Body Encoding
extension Router {
    
    public var bodyEncoding: EncodingType {
        switch self {
        case .sample:
            return .stringAscii
        default:
            return .jsonSerialization
        }
    }
}
