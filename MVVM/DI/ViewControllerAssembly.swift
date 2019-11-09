//
//  ViewControllerAssembly.swift
//  MVVM
//
//  Created by Michal Ziobro on 09/11/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation
import Swinject

class ViewControllerAssembly : Assembly {
    
    func assemble(container: Container) {
        // View Controllers
        container.storyboardInitCompleted(MoviesViewController.self) { r, c in
            c.viewModel = r.resolve(IMoviesListViewModel.self)
        }
        container.storyboardInitCompleted(MoviesListViewController.self) { r, c in
            c.viewModel = r.resolve(IMoviesListViewModel.self)
        }
        container.storyboardInitCompleted(MovieDetailsViewController.self) { r, c in
            c.viewModel = r.resolve(IMovieDetailsViewModel.self)
        }
        container.storyboardInitCompleted(MoviesQueriesListViewController.self) { r, c in
            c.viewModel = r.resolve(IMoviesQueriesListViewModel.self)
        }
    }
    
    
}
