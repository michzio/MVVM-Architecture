//
//  MoviesListViewModel.swift
//  MVVM
//
//  Created by Michal Ziobro on 03/11/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation

import RxSwift
import Action

class MoviesListViewModel : IMoviesListViewModel {
    
    private let disposeBag = DisposeBag()
    
    private let repository: IMoviesRepository
    private let posterImagesRepository: IPosterImagesRepository
    
    init(repository: IMoviesRepository,
         posterImagesRepository: IPosterImagesRepository) {
        self.repository = repository
        self.posterImagesRepository = posterImagesRepository
        
        // reset page while typing new search query
        query
        .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
        .distinctUntilChanged()
        .map { _ in 1 }
        .debug("reset page", trimOutput: false)
        .bind(to: page).disposed(by: disposeBag)
        
    }
    
    var query = PublishSubject<String>()
    var page = BehaviorSubject<Int>(value: 1)
       
    var movies : Observable<[MovieSection]> {

       return Observable.combineLatest(query, page)
                  .debug("combine latest", trimOutput: false)
                  .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
                  .distinctUntilChanged({ (t1, t2) -> Bool in
                        return t1 == t2
                  })
                  .debug("before request", trimOutput: false)
                  .flatMapLatest { tuple -> Observable<(Int, MovieSection)> in
                        let (query, page) = tuple
                    return self.repository.getMovies(query: query, page: page)
                        .map { (page, MovieSection(model: "Page \(page)", items: $0)) }
                    }
                  .scan([]) { (previous, current) -> [MovieSection] in
              
                      if current.0 > 1{
                        return previous + [current.1]
                      } else {
                        return [current.1]
                      }
                }
                .debug("after accumulator", trimOutput: true)
                .distinctUntilChanged()
                
    }
   
    lazy var detailsAction: Action<Movie, Swift.Never> = {
        
        return Action { movie in
            
            let coordinator = DIAppContainer.shared.container.resolve(ISceneCoordinator.self)
            coordinator?.transition(to: .movieDetails(movie: movie), type: .push)
            
            return .never()
        }
    }()
    
}
