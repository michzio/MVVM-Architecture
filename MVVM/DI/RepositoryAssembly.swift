//
//  RepositoryAssembly.swift
//  MVVM
//
//  Created by Michal Ziobro on 09/11/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation
import Swinject

class RepositoryAssembly: Assembly {
    
    func assemble(container: Container) {
        
        // Repositories
        container.register(IMoviesRepository.self) { r in
            // MoviesRepository()
            RxMoviesRepository(service: r.resolve(IMoviesService_Rx.self)!, dao: r.resolve(IMoviesQueryDao_Rx.self)!)
        }
        container.register(IPosterImagesRepository.self) { r in
            // PosterImagesRepository()
            RxPosterImagesRepository(service: r.resolve(IPosterImagesService_Rx.self)!, dao: r.resolve(IPosterImagesDao_Rx.self)!)
        }
    }
    
    
}
