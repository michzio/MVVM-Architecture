//
//  IJSONNetworkService.swift
//  MVVM
//
//  Created by Michal Ziobro on 18/09/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation
import SwiftyJSON

public protocol IJsonNetworkService {
    
     @discardableResult
     func request(with endpoint: Requestable, queue: DispatchQueue, completion: @escaping (Swift.Result<JSON, Error>) -> Void) -> Cancellable?
}

extension IJsonNetworkService where Self : INetworkService {
    
    public func request(with endpoint: Requestable, queue: DispatchQueue = .main, completion: @escaping (Swift.Result<JSON, Error>) -> Void) -> Cancellable? {
          
          return request(with: endpoint, queue: queue) { (result : Swift.Result<Data, Error>) in
              
              switch result {
              case .success(let data):
                  completion(.success(JSON(data)))
              case .failure(let error):
                  completion(.failure(error))
              }
          }
      }
}
