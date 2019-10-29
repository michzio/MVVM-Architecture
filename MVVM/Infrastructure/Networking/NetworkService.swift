//
//  NetworkService.swift
//  MVVM
//
//  Created by Michal Ziobro on 16/09/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation

public final class NetworkService {
    
    private let session: INetworkSession
    private let configuration: INetworkConfiguration
    private let logger: INetworkLogger
    
    internal let decoder: JSONDecoder
    
    init(session: INetworkSession,
         configuration: INetworkConfiguration,
         decoder: JSONDecoder = JSONDecoder(),
         logger: INetworkLogger = NetworkLogger()) {
        self.session = session
        self.configuration = configuration
        self.decoder = decoder
        self.logger = logger
    }
    
    private func request(_ urlRequest: URLRequest, completion: @escaping (Result<Data?, Error>) -> Void) -> Cancellable? {
        
        return session.loadData(from: urlRequest) { [weak self] (data, response, error) in
            
            if let response = response as? HTTPURLResponse {
                self?.logger.log(statusCode: response.statusCode)
                if response.statusCode >= 400 {
                    completion(.failure(NetworkError.statusCode(code: response.statusCode)))
                    return
                }
            }
            
            if let error = error {
                self?.logger.log(error: error)
                completion(.failure(error))
            } else {
                self?.logger.log(response: response, data: data)
                completion(.success(data))
            }
        }
    }
}

extension NetworkService : INetworkService {
    
    public func request<T: Decodable>(with endpoint: Requestable, queue: DispatchQueue = .main, completion: @escaping (Result<T, Error>) -> Void) -> Cancellable? {
        
        do {
            let urlRequest = try endpoint.urlRequest(with: configuration)
            return request(urlRequest) { result in
                switch result {
                case .success(let data):
                    guard let data = data else {
                        queue.async {
                            completion(.failure(NetworkError.empty))
                        }
                        return
                    }
                    do {
                        let result = try self.decoder.decode(T.self, from: data)
                        queue.async {
                            completion(.success(result))
                        }
                    } catch {
                        queue.async {
                            completion(.failure(NetworkError.decoding))
                        }
                    }
                    
                case .failure(let error):
                    queue.async {
                        completion(.failure(error))
                    }
                }
            }
        } catch (let error) {
            completion(.failure(error))
            return nil
        }
        
    }
     
    public func request(with endpoint: Requestable, queue: DispatchQueue = .main, completion: @escaping (Result<Data, Error>) -> Void) -> Cancellable? {
        
        do {
            let urlRequest = try endpoint.urlRequest(with: configuration)
            return request(urlRequest) { result in
                
                switch result {
                case .success(let data):
                    guard let data = data else {
                        queue.async {
                            completion(.failure(NetworkError.empty))
                        }
                        return
                    }
                    queue.async {
                        completion(.success(data))
                    }
                case .failure(let error):
                    queue.async {
                        completion(.failure(error))
                    }
                }
            }
        } catch (let error) {
            completion(.failure(error))
            return nil
        }
    }
}

// MARK: - Helpers
extension NetworkService  {
    
    internal func urlRequest(from endpoint: Requestable) throws -> URLRequest {
        return try endpoint.urlRequest(with: configuration)
    }
    
    internal var urlSession : URLSession {
        return (self.session as? URLSession) ?? URLSession.shared
    }
}

extension NetworkService : IPromiseNetworkService { }
extension NetworkService : IJsonNetworkService { }
