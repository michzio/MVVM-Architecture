//
//  AFNetworkService.swift
//  MVVM
//
//  Created by Michal Ziobro on 17/09/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation
import Alamofire

public final class AFNetworkService {
    
    private let decoder: JSONDecoder
    private let config: INetworkConfiguration
    private let interceptor: RequestInterceptor?
         
    init( decoder: JSONDecoder,
          config: INetworkConfiguration,
         interceptor: RequestInterceptor? = nil) {
        self.decoder = decoder
        self.config = config
        self.interceptor = interceptor
    }
}

extension AFNetworkService : INetworkService {
    
    public func request<T: Decodable>(with endpoint: Requestable, queue: DispatchQueue = .main, completion: @escaping (Result<T, Error>) -> Void) -> Cancellable? {
        
        do {
            
            let urlRequest = try endpoint.urlRequest(with: config)
               
            let dataRequest : DataRequest
            if let interceptor = interceptor {
                dataRequest = AF.request(urlRequest, interceptor: interceptor)
            } else {
                dataRequest = AFAuth.request(urlRequest)
            }
                   
            dataRequest
                .validate(statusCode: 200..<300)
                .validate(contentType: ["application/json"])
                .responseJSON { response in
                       
                guard response.error == nil else {
                    print("Error: \(response.error!)")
                    queue.async { completion(.failure(response.error!)) }
                    return
                }
                           
                guard let data = response.data else {
                    print("Error: empty data")
                    queue.async { completion(.failure(NetworkError.empty)) }
                    return
                }
                   
                do {
                    let object = try self.decoder.decode(T.self, from: data)
                    queue.async { completion(.success(object)) }
                } catch {
                    queue.async {
                        completion(.failure(NetworkError.decoding))
                    }
                }
            }
            
            return dataRequest
           
        } catch (let error) {
            queue.async { completion(.failure(error)) }
            return nil
        }
    }
    
     public func request(with endpoint: Requestable, queue: DispatchQueue = .main, completion: @escaping (Result<Data, Error>) -> Void) -> Cancellable? {
        
        do {
            let urlRequest = try endpoint.urlRequest(with: config)
        
            let dataRequest : DataRequest
            if let interceptor = interceptor {
                dataRequest = AF.request(urlRequest, interceptor: interceptor)
            } else {
                dataRequest = AFAuth.request(urlRequest)
            }
            
            dataRequest
                .validate(statusCode: 200..<300)
                .validate(contentType: ["application/json"])
                .responseJSON { response in
                
                    guard response.error == nil else {
                        print("Error: \(response.error!)")
                        queue.async { completion(.failure(response.error!)) }
                        return
                    }
                    
                    guard let data = response.data else {
                        print("Error: empty data")
                        queue.async { completion(.failure(NetworkError.empty)) }
                        return
                    }
                    
                    queue.async { completion(.success(data)) }
                }
    
            return dataRequest.cancel()
        } catch (let error) {
            queue.async { completion(.failure(error)) }
            return nil 
        }
    }
}

extension AFNetworkService : IPromiseNetworkService { }
extension AFNetworkService : IJsonNetworkService { }


extension Alamofire.Request : Cancellable {
    
    public func doCancel() {
        _ = self.cancel()
    }
}
