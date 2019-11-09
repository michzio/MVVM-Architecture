//
//  AFNetworkService+Rx.swift
//  MVVM
//
//  Created by Michal Ziobro on 30/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation

import Alamofire

import RxSwift

/* TODO: RxAlamofire is not not compatible with Alamofire 5.0 beta framework
import RxAlamofire


extension AFNetworkService : INetworkService_Rx {
    
    public func request<T: Decodable>(with endpoint: Requestable) -> Observable<T> {
        
        do {
            let request = try self.urlRequest(from: endpoint)
                        
            let afSession = SessionManager.default
            
            return afSession.rx.request(urlRequest: request)
                    .validate(statusCode: 200..<300)
                    .validate(contentType: ["application/json"])
                    .data()
                    .map { try self.decoder.decode(T.self, from: $0) }
                    
        } catch {
            return .error(error)
        }
    }
    
    public func response(with endpoint: Requestable) -> Observable<(response: HTTPURLResponse, data: Data)> {
        
        do {
            let request = try self.urlRequest(from: endpoint)
            
            //afSession.rx.
            // if let interceptor =
            let afSession = SessionManager.default
            
            return afSession.rx.request(urlRequest: request)
                .validate(statusCode: 200..<300)
                .responseData()
                .map {
                    let (response, data) = $0
                    return (response: response, data: data)
                }
        } catch {
            return .error(error)
        }
    }
    
    public func data(with endpoint: Requestable) -> Observable<Data> {
        
        do {
            let request = try self.urlRequest(from: endpoint)
            
            let afSession = SessionManager.default
            
            return afSession.rx.request(urlRequest: request)
                .validate(statusCode: 200..<300)
                .data()
        } catch {
            return .error(error)
        }
    }
    
    public func string(with endpoint: Requestable) -> Observable<String> {
        
        do {
            let request = try self.urlRequest(from: endpoint)
        
            let afSession = SessionManager.default
            
            return afSession.rx.request(urlRequest: request)
                    .validate(statusCode: 200..<300)
                    .string(encoding: .utf8)
        } catch {
            return .error(error)
        }
    }
    
    public func json(with endpoint: Requestable) -> Observable<Any> {
        
        do {
            let request = try self.urlRequest(from: endpoint)
            
            let afSession = SessionManager.default
            
            return afSession.rx.request(urlRequest: request)
                        .validate(statusCode: 200..<300)
                        .validate(contentType: ["application/json"])
                        .json()
        } catch {
            return .error(error)
        }
    }
    
    public func image(with endpoint: Requestable) -> Observable<UIImage> {
        
        return self.data(with: endpoint).map { UIImage(data: $0) ?? UIImage() }
        
    }
}
*/
