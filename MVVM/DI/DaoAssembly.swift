//
//  DaoAssembly.swift
//  MVVM
//
//  Created by Michal Ziobro on 09/11/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation
import Swinject

class DaoAssembly : Assembly {
    
    
    func assemble(container: Container) {
        // Daos
        container.register(IMoviesQueryDao_Rx.self) { r in
            // MoviesQueryRealmDao()
            MoviesQueryDao()
        }
        container.register(IPosterImagesDao_Rx.self) { r in
            // PosterImagesRealmDao()
            PosterImagesDao()
        }
    }
    
    
    
}
