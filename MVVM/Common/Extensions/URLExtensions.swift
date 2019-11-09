//
//  URLExtensions.swift
//  MVVM
//
//  Created by Michal Ziobro on 08/11/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation

extension URL {
    func appendQueryParams( params: [String: String]) -> URL? {
        var components = URLComponents(string: self.absoluteString)
        if let queryItems = components?.queryItems {
            components?.queryItems = queryItems + params.map { element in URLQueryItem(name: element.key, value: element.value) }
        } else {
            components?.queryItems = params.map { element in URLQueryItem(name: element.key, value: element.value) }
        }
        return components?.url
    }
}
