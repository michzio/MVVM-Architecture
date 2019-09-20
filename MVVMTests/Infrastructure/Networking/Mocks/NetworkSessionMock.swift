//
//  NetworkSessionMock.swift
//  MVVMTests
//
//  Created by Michal Ziobro on 20/09/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation
@testable import MVVM

struct NetworkSessionMock : INetworkSession, Cancellable {
    
    let data: Data?
    let response: HTTPURLResponse?
    let error: Error?
    
    func loadData(from request: URLRequest,
                  completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> Cancellable? {
        completion(data, response, error)
        return self
    }
    
    func doCancel() { }
}
