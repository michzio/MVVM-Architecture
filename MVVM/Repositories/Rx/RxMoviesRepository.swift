//
//  RxMoviesRepository.swift
//  MVVM
//
//  Created by Michal Ziobro on 30/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation
import RxSwift

final class RxMoviesRepository {
    
    private let maxAttampts = 5
    
    private let moviesService: IMoviesService_Rx
    private let moviesQueryDao: IMoviesQueryDao_Rx
    
    init(service: IMoviesService_Rx, dao: IMoviesQueryDao_Rx) {
        self.moviesService = service
        self.moviesQueryDao = dao
    }
        
    let disposeBag = DisposeBag()
}

extension RxMoviesRepository : IMoviesRepository {
    
    func getMovies(query: String, page: Int) -> Observable<[Movie]> {
        
        // Cached Local Storage Sequence
        let movies = moviesQueryDao.load(query: query, page: page)
            .map { (query: MoviesQuery?) -> [Movie] in
                guard let query = query else { return [] }
                
                return query.results.sorted {
                    ($0.releaseDate ?? "") > ($1.releaseDate ?? "")
                
                }
            }
        .debug("load movies", trimOutput: true)
        
        
        // Remote API
        _ = moviesService.getMovies(query: query, page: page)
            .debug("movies request", trimOutput: true)
            .flatMap { [weak self] moviesQuery -> Observable<MoviesQuery> in
                guard let self = self else { return .empty() }
                var mq = moviesQuery
                    mq.query = query
                return self.moviesQueryDao.sync(moviesQuery: mq)
            }
            .delay(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe({  moviesQuery in
                print("Movies query synced to local database.")
            }).disposed(by: disposeBag)
        
        return movies
    }
}


/* Error Handling with retryWhen - but doesn't work as expected
.retryWhen { errors in
               
           return errors.enumerated().flatMap { (arg) -> Observable<Int> in
               
               let (attampt, error) = arg
               if attampt > self.maxAttampts - 1 {
                       return Observable.error(error)
               } else if let daoError = error as? DaoError, daoError != .notFound {
                       return Observable.error(error)
               }
                   
               return Observable.timer(Double(attampt+1), scheduler: MainScheduler.instance).take(1)
               }
       }
       .catchErrorJustReturn([])
*/


