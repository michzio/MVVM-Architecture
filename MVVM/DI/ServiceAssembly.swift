//
//  ServiceAssembly.swift
//  MVVM
//
//  Created by Michal Ziobro on 09/11/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation
import Swinject

class ServiceAssembly : Assembly {
    
    func assemble(container: Container) {
        // Services
        container.register(IMoviesService_Rx.self) { r in
            MoviesService(networkService: r.resolve((INetworkService & INetworkService_Rx).self, name: "api")! )
        }
        container.register(IPosterImagesService_Rx.self) { r in
            PosterImagesService(networkService: r.resolve((INetworkService & INetworkService_Rx).self, name: "images")! )
        }
    }
}
