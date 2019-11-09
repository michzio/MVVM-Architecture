//
//  IMoviesQueriesRepository.swift
//  MVVM
//
//  Created by Michal Ziobro on 31/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation
import RxSwift

protocol IMoviesQueriesRepository {
    
    func recentQueries(number: Int) -> Observable<[MoviesQuery]>
    func sync(query: MoviesQuery) -> Observable<MoviesQuery>
}
