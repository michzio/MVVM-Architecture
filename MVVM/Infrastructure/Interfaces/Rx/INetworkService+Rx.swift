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
    
    func request<T: Decodable>(with endpoint: Requestable) -> Observable<T>
    
    func response(with endpoint: Requestable) -> Observable<(response: HTTPURLResponse, data: Data)>
    func data(with endpoint: Requestable) -> Observable<Data>
    func string(with endpoint: Requestable) -> Observable<String>
    func json(with endpoint: Requestable) -> Observable<Any>
    func image(with endpoint: Requestable) -> Observable<UIImage>
}
