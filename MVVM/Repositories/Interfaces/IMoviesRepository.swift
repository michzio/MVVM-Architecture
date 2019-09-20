//
//  IMoviesRepository.swift
//  MVVM
//
//  Created by Michal Ziobro on 19/09/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation
import RxSwift

protocol IMoviesRepository {
    
    func getMovies(query: String, page: Int) -> Observable<MoviesPage>
}
