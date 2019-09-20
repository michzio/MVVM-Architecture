//
//  IMoviesService.swift
//  MVVM
//
//  Created by Michal Ziobro on 18/09/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation

protocol IMoviesService {
    
    func getMovies(query: String, page: Int, completion: @escaping (Result<MoviesPage, Error>) -> Void ) -> Cancellable?
}
