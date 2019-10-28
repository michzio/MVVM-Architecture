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

extension PosterImage : Hashable {
    
    static func == (lhs: PosterImage, rhs: PosterImage) -> Bool {
        return lhs.path == rhs.path && lhs.width == rhs.width
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(path)
        hasher.combine(width)
    }
}
