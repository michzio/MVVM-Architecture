//
//  PosterImagesService+Rx.swift
//  MVVM
//
//  Created by Michal Ziobro on 30/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation

import RxSwift

extension PosterImagesService : IPosterImagesService_Rx {
    
    func getPosterImage(path: String, width: Int) -> Observable<PosterImage> {
        
        let requestable = Router.moviePoster(path: path, width: width)
        
        return networkService.data(with: requestable)
            .map { data in
                PosterImage(path: path, width: width, data: data)
            }
    }
}
