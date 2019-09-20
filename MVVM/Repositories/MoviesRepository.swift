//
//  MoviesRepository.swift
//  MVVM
//
//  Created by Michal Ziobro on 16/09/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation
import RxSwift

final class MoviesRepository {
    
    private let moviesService : IMoviesService
    private let moviesDao : IMoviesDao
    
    init(service: IMoviesService, dao: IMoviesDao) {
        self.moviesService = service
        self.moviesDao = dao
    }
}

extension MoviesRepository: IMoviesRepository {
    
    func getMovies(query: String, page: Int) -> Observable<MoviesPage> {
        
        let subject = PublishSubject<MoviesPage>()
    
        // Cached Local Storage
        
        
        // Remote API
        _ = moviesService.getMovies(query: query, page: page) { (result) in
            
            switch result {
            case .success(let movies):
                subject.onNext(movies)
            case .failure(let error):
                subject.onError(error)
            }
        }
        
        return subject.asObservable()
    }
}
