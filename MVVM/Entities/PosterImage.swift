//
//  PosterImage.swift
//  MVVM
//
//  Created by Michal Ziobro on 25/09/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation

struct PosterImage {
    
    var path: String
    var width: Int
    var data: Data 
    
}

extension PosterImage : Identifiable {
    
    var _identifier: String {
        return "\(path)-\(width)"
    }
}
