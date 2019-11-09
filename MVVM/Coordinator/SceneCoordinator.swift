//
//  SceneCoordinator.swift
//  MVVM
//
//  Created by Michal Ziobro on 04/11/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa

class SceneCoordinator: NSObject, ISceneCoordinator {
    
    private var window: UIWindow
    private var currentViewController: UIViewController
    
    required init(window: UIWindow) {
        self.window = window
        self.currentViewController = window.rootViewController!
    }
}

// MARK: - Helpers
extension SceneCoordinator {
    
    static func actualViewController(for viewController: UIViewController) -> UIViewController {
        if let navigationController = viewController as? UINavigationController {
            return navigationController.viewControllers.first!
        } else {
            return viewController
        }
    }
}

extension SceneCoordinator {
    
    @discardableResult
    func transition(to scene: Scene, type: SceneTransitionType) -> Completable {
        
        let subject = PublishSubject<Void>()
        
        let vc = scene.viewController
        
        switch type {
        case .root:
            
            currentViewController = SceneCoordinator.actualViewController(for: vc)
            window.rootViewController = vc
            subject.onCompleted()
            
        case .push:
            
            guard let nc = currentViewController.navigationController else {
                fatalError("Can't push a view controller without a current navigation controller")
            }
            
            // set coordinator as the navigation controller's delegate
            // do this prior navigationController.rx.delegate as it
            // takes care of preserving the configured delegate
            nc.delegate = self
            
            // subscription to be notified when push complete
            _ = nc.rx.delegate  .sentMessage(#selector(UINavigationControllerDelegate.navigationController(_:didShow:animated:)))
                .map { _ in }
                .bind(to: subject)
            
            nc.pushViewController(vc, animated: true)
            
        case .modal:
        
            currentViewController.present(vc, animated: true) {
                subject.onCompleted()
            }
            currentViewController = SceneCoordinator.actualViewController(for: vc)
            
        case .embed(let container):
            
            currentViewController.add(child: vc, container: container)
            currentViewController = vc
            subject.onCompleted()
        }
        
        return subject.asObservable()
                     .take(1)
                     .ignoreElements()
    }
}

extension SceneCoordinator {
    
    @discardableResult
    func pop(animated: Bool) -> Completable {
        
        let subject = PublishSubject<Void>()
        
        if let presenter = currentViewController.presentingViewController {
            
            // dismiss modally presented controller
            presenter.dismiss(animated: animated) {
                self.currentViewController = SceneCoordinator.actualViewController(for: presenter)
                subject.onCompleted()
            }
        } else if let navigationController = currentViewController.navigationController {
            
            // coordinator has been set as delegate of navigation controller
            // during the push transition
            
            // navigate up the stack
            // subscribe to be notified when pop complete
            _ = navigationController.rx.delegate
                .sentMessage(#selector(UINavigationControllerDelegate.navigationController(_:didShow:animated:)))
                    .map { _ in }
                    .bind(to: subject)
            
            guard navigationController.popViewController(animated: animated) != nil else {
                fatalError("can't navigate back from \(currentViewController)")
            }
        } else if let parent = currentViewController.parent {
            // is child view controller embed in parent view controller
            currentViewController.remove()
            currentViewController = parent
            subject.onCompleted()
        }
        
        return subject.asObserver()
                      .take(1)
                      .ignoreElements()
    }
}

// MARK: - Navigation Controller Delegate
extension SceneCoordinator : UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        currentViewController = viewController
    }
}
