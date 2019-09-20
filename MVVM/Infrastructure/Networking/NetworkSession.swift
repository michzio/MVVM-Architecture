//
//  NetworkSession.swift
//  MVVM
//
//  Created by Michal Ziobro on 16/09/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation

protocol INetworkSession {
    func loadData(from request: URLRequest,
                  completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> Cancellable? 
}

extension URLSession : INetworkSession {
    
    func loadData(from request: URLRequest,
                  completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> Cancellable? {
        
        let task = dataTask(with: request) { (data, response, error) in
            completion(data, response, error)
        }
        task.resume()
        
        return task 
    }
    
}

extension URLSessionTask : Cancellable {
    
    public func doCancel() {
        self.cancel()
    }
}
