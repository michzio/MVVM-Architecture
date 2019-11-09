//
//  RxMoviesQueriesRepository.swift
//  MVVM
//
//  Created by Michal Ziobro on 31/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation
import RxSwift

final class RxMoviesQueriesRepository {
    
    private let service: IMoviesService_Rx
    private let dao: IMoviesQueryDao_Rx
    
    init(service: IMoviesService_Rx, dao: IMoviesQueryDao_Rx) {
        self.service = service
        self.dao = dao
    }
}

extension RxMoviesQueriesRepository : IMoviesQueriesRepository {
    func recentQueries(number: Int) -> Observable<[MoviesQuery]> {
        return dao.recent(number: number)
    }
    
    func sync(query: MoviesQuery) -> Observable<MoviesQuery> {
        return dao.sync(moviesQuery: query)
    }
    
    
    
}
