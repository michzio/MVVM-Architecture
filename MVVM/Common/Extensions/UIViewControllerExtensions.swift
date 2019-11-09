//
//  StoryboardLoadable.swift
//  MVVM
//
//  Created by Michal Ziobro on 31/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import UIKit

extension UIViewController {
    
    @objc class var identifier : String {
        return String(describing: self)
    }
}

extension UIViewController {
    
    @objc func add(child: UIViewController, container: UIView) {
        addChild(child)
        container.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    func remove() {
        guard parent != nil else { return }
        willMove(toParent: nil)
        removeFromParent()
        view.removeFromSuperview()
    }
}
