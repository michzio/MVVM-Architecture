//
//  MoviesService+Rx.swift
//  MVVM
//
//  Created by Michal Ziobro on 30/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation
import RxSwift

extension MoviesService : IMoviesService_Rx {
    
    func getMovies(query: String, page: Int) -> Observable<MoviesQuery> {
        
        let requestable = Router.movies(query: query, page: page)
        //let requestable = Endpoints.movies(query: query, page: page)
        
        return networkService.request(with: requestable)
    }
    
}
