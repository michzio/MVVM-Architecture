//
//  IPosterImagesService.swift
//  MVVM
//
//  Created by Michal Ziobro on 25/09/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation

protocol IPosterImagesService {
    
    func getPosterImage(path: String, width: Int, completion: @escaping (Result<PosterImage, Error>) -> Void ) -> Cancellable?
}
