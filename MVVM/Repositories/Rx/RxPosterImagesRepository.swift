//
//  RxPosterImageRepository.swift
//  MVVM
//
//  Created by Michal Ziobro on 30/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation
import RxSwift

final class RxPosterImagesRepository {
    
    private let posterImagesService: IPosterImagesService_Rx
    private let posterImagesDao: IPosterImagesDao_Rx
    
    init(service: IPosterImagesService_Rx, dao: IPosterImagesDao_Rx) {
        self.posterImagesDao = dao
        self.posterImagesService = service
    }
    
    let disposeBag = DisposeBag()
}


extension RxPosterImagesRepository: IPosterImagesRepository {
    
    func image(with imagePath: String, width: Int) -> Observable<PosterImage?> {
        
        let sizes = [92, 185, 500, 780]
        let availableWidth = (sizes.sorted().first { width <= $0 } ) ?? sizes.last!
    
        // Cached Local Storage Sequence
        let posterImage : Observable<PosterImage?> = posterImagesDao.load(imagePath: imagePath, width: availableWidth)
            .debug("load poster image")
        
        // Remote API
        _ = posterImagesService.getPosterImage(path: imagePath, width: availableWidth)
            .flatMap { [weak self] image -> Observable<PosterImage> in
                guard let self = self else { return .empty() }
                
                return self.posterImagesDao.insertReplacing(image)
        }.subscribe(onNext: { image in
             print("Poster image inserted to local database.")
        }, onError: { error in
            print("Poser image insertion error: \(error)")
        }).disposed(by: disposeBag)
        
        return posterImage
    }
    
    
}
