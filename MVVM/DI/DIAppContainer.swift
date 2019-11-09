//
//  AppContainer.swift
//  MVVM
//
//  Created by Michal Ziobro on 03/11/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation

import Swinject
import SwinjectStoryboard 
import SwinjectAutoregistration

public class DIAppContainer {
    
    static var shared = DIAppContainer()
    
    let container = Container()
    let assembler: Assembler
    
    private init() {
        
        // the assembler gathers all the dependencies in one place
        assembler = Assembler([
            HelperAssembly(),
            ServiceAssembly(),
            DaoAssembly(),
            RepositoryAssembly(),
            ViewModelAssembly(),
            ViewControllerAssembly()
        ], container: container)
    }
}


extension DIAppContainer {
    
    func makeMoviesViewController() -> MoviesViewController {
            
            let bundle = Bundle(for: MoviesViewController.self)
            let storyboard = SwinjectStoryboard.create(name: "Movies", bundle: bundle, container: container)
            return storyboard.instantiateViewController(withIdentifier: MoviesViewController.identifier) as! MoviesViewController
    }
    
    func makeMoviesListViewController() -> MoviesListViewController {
        
        let bundle = Bundle(for: MoviesListViewController.self)
        let storyboard = SwinjectStoryboard.create(name: "Movies", bundle: bundle, container: container)
        return storyboard.instantiateViewController(withIdentifier: MoviesListViewController.identifier) as! MoviesListViewController
    }
    
    func makeMovieDetailsViewController(movie: Movie) -> MovieDetailsViewController {
        
        //let container = AppContainer.shared
        
        let bundle = Bundle(for: MovieDetailsViewController.self)
        let storyboard = SwinjectStoryboard.create(name: "MovieDetails", bundle: bundle, container: container)
        let vc = storyboard.instantiateViewController(withIdentifier: MovieDetailsViewController.identifier) as! MovieDetailsViewController
        
        vc.viewModel.setMovie(movie)
        return vc
    }
    
    func makeMoviesQueriesListViewController() -> MoviesQueriesListViewController
    {
    
        let bundle = Bundle(for: MoviesQueriesListViewController.self)
        let storyboard = SwinjectStoryboard.create(name: "MoviesQueriesList", bundle: bundle, container: container)
        
        return storyboard.instantiateViewController(withIdentifier: MoviesQueriesListViewController.identifier) as! MoviesQueriesListViewController
    }
}

