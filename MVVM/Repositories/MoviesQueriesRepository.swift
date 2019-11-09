//
//  MoviesQueriesRepository.swift
//  MVVM
//
//  Created by Michal Ziobro on 31/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation
import RxSwift

final class MoviesQueriesRepository {
    
    private let service: IMoviesService
    private let dao: IMoviesQueryDao
    
    init(service: IMoviesService, dao: IMoviesQueryDao) {
        self.service = service
        self.dao = dao
    }
}

extension MoviesQueriesRepository : IMoviesQueriesRepository {
    
    func recentQueries(number: Int) -> Observable<[MoviesQuery]> {
        
        return Observable.create { observer -> Disposable in
            
            self.dao.recent(number: number) { result in
                
                switch result {
                case .success(let queries):
                    observer.onNext(queries)
                case .failure:
                    observer.onNext([])
                }
            }
            
            return Disposables.create()
        }
    }
    
    func sync(query: MoviesQuery) -> Observable<MoviesQuery> {
        
        return Observable.create { observer -> Disposable in
            
            self.dao.sync(moviesQuery: query) { result in
                       
                switch result {
                case .success(let query):
                    observer.onNext(query)
                case .failure(let error):
                    observer.onError(error)
                }
            }
            
            return Disposables.create()
        }
    }
    
    
}
