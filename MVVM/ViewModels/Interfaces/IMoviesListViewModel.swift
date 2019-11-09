//
//  IMoviesListViewModel.swift
//  MVVM
//
//  Created by Michal Ziobro on 03/11/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation
import RxSwift
import Action 

protocol IMoviesListViewModel {
    
    // MARK: - Input
    var query: PublishSubject<String> { get }
    var page: BehaviorSubject<Int> { get }
    
    var detailsAction:  Action<Movie, Swift.Never> { get }
    
    // MARK: - Output
    var movies: Observable<[MovieSection]> { get }
}
