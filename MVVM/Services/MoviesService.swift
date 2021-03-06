//
//  MoviesService.swift
//  MVVM
//
//  Created by Michal Ziobro on 16/09/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation


public final class MoviesService {
    
    internal let networkService: INetworkService & INetworkService_Rx
    
    public init(networkService: INetworkService & INetworkService_Rx) {
        self.networkService = networkService
    }
}

extension MoviesService : IMoviesService {
    
    func getMovies(query: String, page: Int, completion: @escaping (Result<MoviesQuery, Error>) -> Void) -> Cancellable? {
        
        let requestable = Router.movies(query: query, page: page)
        //let requestable = Endpoints.movies(query: query, page: page)
        
        return networkService.request(with: requestable, queue: .main) { (result : Result<MoviesQuery, Error>) in
            
            switch result {
            case .success(var moviesQuery):
                moviesQuery.query = query 
                completion(.success(moviesQuery))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
