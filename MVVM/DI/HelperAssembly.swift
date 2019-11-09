//
//  HelperAssembly.swift
//  MVVM
//
//  Created by Michal Ziobro on 09/11/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation
import Swinject

class HelperAssembly : Assembly {
    
    func assemble(container: Container) {
        
        // Coordinator
        container.register(ISceneCoordinator.self) { r in
            let window: UIWindow
            
            if #available(iOS 13.0, *) {
                window = ((UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window)!
            } else {
                window = ((UIApplication.shared.delegate as? AppDelegate)?.window)!
            }
            
            return SceneCoordinator(window: window)
        }.inObjectScope(.container)
        
        // Network Service
        container.register((INetworkService & INetworkService_Rx).self, name: "api") { r in
           
            let baseURL = URL(string: AppSettings.shared.apiBaseURL)!
            let apiKey = AppSettings.shared.apiKey
            let configuration = NetworkConfiguaration(baseURL: baseURL,
                                                      queryParams: ["api_key": apiKey])
            return NetworkService(session: URLSession.shared, configuration: configuration)
        }
        container.register((INetworkService & INetworkService_Rx).self, name: "images") { r in
            
            let baseURL = URL(string: AppSettings.shared.imagesBaseURL)!
            let configuration = NetworkConfiguaration(baseURL: baseURL)
            return NetworkService(session: URLSession.shared, configuration: configuration)
        }
        
    }
    
    
}
