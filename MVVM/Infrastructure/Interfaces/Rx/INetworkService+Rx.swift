//
//  INetworkService+Rx.swift
//  MVVM
//
//  Created by Michal Ziobro on 29/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation

import RxSwift

public protocol INetworkService_Rx {
    
    func request<T: Decodable>(with endpoint: Requestable, queue: DispatchQueue) -> Observable<T>
    
    func response(with endpoint: Requestable, queue: DispatchQueue) -> Observable<(response: HTTPURLResponse, data: Data)> 
    func data(with endpoint: Requestable, queue: DispatchQueue) -> Observable<Data>
    func string(with endpoint: Requestable, queue: DispatchQueue) -> Observable<String>
    func json(with endpoint: Requestable, queue: DispatchQueue) -> Observable<Any>
    func image(with endpoint: Requestable, queue: DispatchQueue) -> Observable<UIImage>
}
