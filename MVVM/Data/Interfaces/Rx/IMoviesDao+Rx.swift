//
//  IMoviesDao+Rx.swift
//  MVVM
//
//  Created by Michal Ziobro on 27/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation
import RxSwift

protocol IMoviesDao_Rx {
    
    func load(query: String) -> Observable<[Movie]>
    func sync(movies: [Movie]) -> Observable<Bool>
    
    // IDao_Rx
    func insert(_ e: Movie) -> Observable<Movie>
    func insertReplacing(_ e: Movie) -> Observable<Movie>
    func delete(_ e: Movie) -> Observable<Int>
    func update(_ e: Movie) -> Observable<Movie>
    func load(id: String) -> Observable<Movie>
    func loadAll() -> Observable<[Movie]>
}
