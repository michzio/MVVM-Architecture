//
//  IMoviesService+Rx.swift
//  MVVM
//
//  Created by Michal Ziobro on 30/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation
import RxSwift

protocol IMoviesService_Rx {
    
    func getMovies(query: String, page: Int) -> Observable<MoviesQuery>
}
