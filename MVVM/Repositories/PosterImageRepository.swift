//
//  PosterImageRepository.swift
//  MVVM
//
//  Created by Michal Ziobro on 25/09/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation
import RxSwift

final class PosterImagesRepository {
    
    private let posterImagesService : IPosterImagesService
    private let posterImagesDao : IPosterImagesDao
    
    init(service: IPosterImagesService, dao: IPosterImagesDao) {
        self.posterImagesService = service
        self.posterImagesDao = dao
    }
}

extension PosterImagesRepository {
    
    func image(with imagePath: String, width: Int) -> Observable<PosterImage?> {
        
        let subject = PublishSubject<PosterImage?>()
        
        // Cached Local Storage
        posterImagesDao.load(imagePath: imagePath, width: width) { (result) in
            switch result {
            case .success(let posterImage):
                subject.onNext(posterImage)
            default:
                subject.onNext(nil)
            }
        }
        
        // Remote API
        _ = posterImagesService.getPosterImage(path: imagePath, width: width, completion: { result in
            
            switch result {
            case .success(let posterImage):
                self.posterImagesDao.insertReplacing(posterImage) { result in
                    switch result {
                    case .success(let posterImage):
                        subject.onNext(posterImage)
                    case .failure(let error):
                        subject.onError(error)
                    }
                }
            
            case .failure(let error):
                subject.onError(error)
            }
        })
        
        return subject.asObservable()
    }
}
