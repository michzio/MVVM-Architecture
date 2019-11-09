//
//  NetworkSessionMock.swift
//  MVVMTests
//
//  Created by Michal Ziobro on 20/09/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation

import RxSwift

@testable import MVVM

class NetworkSessionMock : INetworkSession, Cancellable {
    
    let data: Data?
    let response: HTTPURLResponse?
    let error: Error?
    
    func loadData(from request: URLRequest,
                  completion: @escaping (Data?, URLResponse?, Error?) -> Void) -> Cancellable? {
        completion(data, response, error)
        return self
    }
    
    func doCancel() { }
    
    init(data: Data?, response: HTTPURLResponse?, error: Error?) {
        self.data = data
        self.response = response
        self.error = error
    }
}

extension Reactive where Base: NetworkSessionMock {
    
    func data(request: URLRequest) -> Observable<Data> {
        
        return Observable.create { (observer) -> Disposable in

            guard let data = self.base.data else {
                if let error = self.base.error {
                    observer.onError(error)
                } else {
                    observer.onCompleted()
                }
                return Disposables.create()
            }
            observer.onNext(data)
            observer.onCompleted()
            
            return Disposables.create()
        }
    }
}
