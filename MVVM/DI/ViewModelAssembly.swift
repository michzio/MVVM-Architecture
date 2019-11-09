//
//  ViewModelAssembly.swift
//  MVVM
//
//  Created by Michal Ziobro on 09/11/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation
import Swinject

class ViewModelAssembly : Assembly {
    
    
    func assemble(container: Container) {
        
        // View Models
        container.register(IMoviesViewModel.self) { r in
            MoviesViewModel()
        }
        container.register(IMoviesListViewModel.self) { r in
            
            MoviesListViewModel(repository: r.resolve(IMoviesRepository.self)!, posterImagesRepository: r.resolve(IPosterImagesRepository.self)!)
        }.inObjectScope(.container)
        
        container.register(IMovieItemViewModel.self) { r in
            MovieItemViewModel(repository: r.resolve(IPosterImagesRepository.self)!)
        }
        container.register(IMovieDetailsViewModel.self) { r in
            MovieDetailsViewModel()
        }
        container.register(IMoviesQueriesListViewModel.self) { r in
            MoviesQueriesListViewModel()
        }
    }

}
