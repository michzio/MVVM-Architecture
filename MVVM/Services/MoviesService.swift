//
//  MoviesService.swift
//  MVVM
//
//  Created by Michal Ziobro on 16/09/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation


public final class MoviesService {
    
    private let networkService: INetworkService
    
    public init(networkService: INetworkService) {
        self.networkService = networkService
    }
}

extension MoviesService : IMoviesService {
    
    func getMovies(query: String, page: Int, completion: @escaping (Result<MoviesPage, Error>) -> Void) -> Cancellable? {
        
        let requestable = Router.movies(query: query, page: page)
        //let requestable = Endpoints.movies(query: query, page: page)
        
        return networkService.request(with: requestable, queue: .main) { (result : Result<MoviesPage, Error>) in
            
            switch result {
            case .success(let moviesPage):
                completion(.success(moviesPage))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
