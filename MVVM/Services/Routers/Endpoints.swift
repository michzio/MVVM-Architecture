//
//  Endpoints.swift
//  MVVM
//
//  Created by Michal Ziobro on 18/09/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation

struct Endpoints {
    
    static func movies(query: String, page: Int) -> Endpoint {
        
        return Endpoint(path: "3/search/movie", queryParams: ["query" : query, "page" : "\(page)"])
    }
    
    static func moviePoster(path: String, width: Int) -> Endpoint {
        
        let sizes = [92, 185, 500, 780]
        let availableWidth = sizes.sorted().first { width <= $0 } ?? sizes.last
        return Endpoint(path: "t/p/w\(availableWidth!)\(path)")
    }
}
