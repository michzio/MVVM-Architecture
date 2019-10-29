//
//  IPromiseNetworkService.swift
//  MVVM
//
//  Created by Michal Ziobro on 18/09/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation
import PromiseKit

public protocol IPromiseNetworkService {
    
    func request<T: Decodable>(with endpoint: Requestable, queue: DispatchQueue) -> Promise<T>
}

extension IPromiseNetworkService where Self : INetworkService {
    
    public func request<T: Decodable>(with endpoint: Requestable, queue: DispatchQueue) -> Promise<T> {
           
           return Promise<T> { seal in
               
               self.request(with: endpoint, queue: queue) { (result: Swift.Result<T, Error>) in
                   
                   switch result {
                   case .success(let object):
                       seal.fulfill(object)
                   case .failure(let error):
                       seal.reject(error)
                   }
               }
           }
       }
}
