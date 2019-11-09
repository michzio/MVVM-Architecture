//
//  File.swift
//  MVVM
//
//  Created by Michal Ziobro on 04/11/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import UIKit

enum Scene {
    case movies
    case moviesList
    case movieDetails(movie: Movie)
    case moviesQueriesList
}

extension Scene {
    
    var viewController : UIViewController {
    
        switch self {
        case .movies:
            let moviesViewController = DIAppContainer.shared.makeMoviesViewController()
            return UINavigationController(rootViewController: moviesViewController)
        case .moviesList:
            return DIAppContainer.shared.makeMoviesListViewController()
        case .movieDetails(let movie):
            return DIAppContainer.shared.makeMovieDetailsViewController(movie: movie)
        case .moviesQueriesList:
            return DIAppContainer.shared.makeMoviesQueriesListViewController()
        }
    }
}
