//
//  LoginScope.swift
//  MVVM
//
//  Created by Michal Ziobro on 09/11/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation
import Swinject

extension ObjectScope {
    
    static let loginScope = ObjectScope(storageFactory: PermanentStorage.init, description: "login scope")
}


// usage
// .inObjectScope(.loginScope)
// let container = ...
// container.resetObjectScope(.loginScope)
