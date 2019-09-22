//
//  MovieUserDefaultsDao.swift
//  MVVM
//
//  Created by Michal Ziobro on 21/09/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation

class MoviesUserDefaultsDao : UserDefaultsDao<Movie>, IMoviesDao {
    
    func load(query: String, completion: @escaping (Result<[Movie], Error>) -> Void) {
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            
            let movies = self.storage.entities
            
            let filtered = movies.filter {
                $0.title.contains(query) || $0.overview.contains(query)
            }
            
            completion(.success(filtered))
        }
    }
    
    func sync(movies: [Movie], completion: @escaping (Result<Bool, Error>) -> Void) {
        // TODO: 
    }
}
