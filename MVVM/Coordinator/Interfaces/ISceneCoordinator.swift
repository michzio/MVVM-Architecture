//
//  ISceneCoordinator.swift
//  MVVM
//
//  Created by Michal Ziobro on 04/11/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation

import RxSwift

enum SceneTransitionType {
    // can be extended to add animated transition types,
    // interactive transitions or even child view controllers
    
    case root
    case push
    case modal
    
    case embed(container: UIView)
}

protocol ISceneCoordinator {
    
    /// transition to another scene
    @discardableResult
    func transition(to scene: Scene, type: SceneTransitionType) -> Completable
    
    /// pop scene from navigation stack or dismiss current modal
    @discardableResult
    func pop(animated: Bool) -> Completable
}

extension ISceneCoordinator {
    
    @discardableResult
    func pop() -> Completable {
        return pop(animated: true)
    }
}
