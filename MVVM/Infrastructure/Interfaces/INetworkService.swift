//
//  INetworkService.swift
//  MVVM
//
//  Created by Michal Ziobro on 29/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation

enum NetworkError : Error {
    case empty
    case decoding
    case statusCode(code: Int)
}

public protocol INetworkService {
    
    @discardableResult
    func request<T: Decodable>(with endpoint: Requestable, queue: DispatchQueue, completion: @escaping (Result<T, Error>) -> Void) -> Cancellable?
    @discardableResult
    func request(with endpoint: Requestable, queue: DispatchQueue, completion: @escaping (Result<Data, Error>) -> Void) -> Cancellable?
}
