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
    private let moviesQueryDao : IMoviesQueryDao
    
    init(service: IMoviesService, dao: IMoviesQueryDao) {
        self.moviesService = service
        self.moviesQueryDao = dao
    }
}

extension MoviesRepository: IMoviesRepository {
    
    func getMovies(query: String, page: Int) -> Observable<[Movie]> {
        
        let subject = PublishSubject<[Movie]>()
    
        // Cached Local Storage
        moviesQueryDao.load(query: query, page: page) { result in
            switch result {
            case .success(let moviesQuery):
                subject.onNext(moviesQuery.results)
            case .failure:
                subject.onNext([])
            }
        }
        
        // Remote API
        _ = moviesService.getMovies(query: query, page: page) { [weak self] (result) in
            guard let self = self else { return }
        
            switch result {
            case .success(let moviesQuery):
                self.moviesQueryDao.sync(moviesQuery: moviesQuery) { result in
                    switch result {
                    case .success(let moviesQuery):
                        subject.onNext(moviesQuery.results)
                    case .failure(let error):
                        subject.onError(error)
                    }
                }
            case .failure(let error):
                subject.onError(error)
            }
        }
        
        return subject.asObservable()
    }
}
