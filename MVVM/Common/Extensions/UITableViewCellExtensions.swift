//
//  UITableViewCellExtensions.swift
//  MVVM
//
//  Created by Michal Ziobro on 08/11/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import UIKit

extension UITableViewCell {
    
    @objc class var identifier : String {
        return String(describing: self)
    }
}
