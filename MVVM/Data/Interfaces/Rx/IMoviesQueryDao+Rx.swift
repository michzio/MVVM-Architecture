//
//  IMoviesQueryDao+Rx.swift
//  MVVM
//
//  Created by Michal Ziobro on 27/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation
import RxSwift

protocol IMoviesQueryDao_Rx {
    
    func load(query: String, page: Int) -> Observable<MoviesQuery>
    func recent(number: Int) -> Observable<[MoviesQuery]>
    func sync(moviesQuery: MoviesQuery) -> Observable<MoviesQuery>
    
    // IDao_Rx
    func insert(_ e: MoviesQuery) -> Observable<MoviesQuery>
    func insertReplacing(_ e: MoviesQuery) -> Observable<MoviesQuery>
    func delete(_ e: MoviesQuery) -> Observable<Int>
    func update(_ e: MoviesQuery) -> Observable<MoviesQuery>
    func load(id: String) -> Observable<MoviesQuery>
    func loadAll() -> Observable<[MoviesQuery]>
}
