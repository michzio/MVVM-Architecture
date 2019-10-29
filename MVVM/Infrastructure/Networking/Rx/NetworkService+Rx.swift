//
//  NetworkService+Rx.swift
//  MVVM
//
//  Created by Michal Ziobro on 29/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

extension NetworkService : INetworkService_Rx {
    
    public func request<T>(with endpoint: Requestable) -> Observable<T> where T : Decodable {
        
        self.data(with: endpoint).map { try self.decoder.decode(T.self, from: $0) }
    }
    
    public func response(with endpoint: Requestable) -> Observable<(response: HTTPURLResponse, data: Data)> {
        
        do {
            let request = try self.urlRequest(from: endpoint)
            return urlSession.rx.response(request: request)
        } catch {
            return .error(error)
        }
    }
    
    public func data(with endpoint: Requestable) -> Observable<Data> {
        
        do {
            let request = try self.urlRequest(from: endpoint)
            return urlSession.rx.data(request: request)
        } catch {
            return .error(error)
        }
    }
    
    public func string(with endpoint: Requestable, queue: DispatchQueue) -> Observable<String> {
        
        return self.data(with: endpoint).map { String(data: $0, encoding:.utf8) ?? "" }
    }
    
    public func json(with endpoint: Requestable, queue: DispatchQueue) -> Observable<Any> {
        
        return self.data(with: endpoint).map { try JSONSerialization.jsonObject(with: $0) }
    }
    
    public func image(with endpoint: Requestable, queue: DispatchQueue) -> Observable<UIImage> {
        return self.data(with: endpoint).map { UIImage(data: $0) ?? UIImage() }
    }
}
