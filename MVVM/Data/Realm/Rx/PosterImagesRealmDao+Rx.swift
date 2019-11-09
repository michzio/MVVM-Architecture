//
//  PosterImagesRealmDao+Rx.swift
//  MVVM
//
//  Created by Michal Ziobro on 27/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation

import RxSwift

import RealmSwift
import RxRealm

extension PosterImagesRealmDao : IPosterImagesDao_Rx {
    
    func load(imagePath: String, width: Int) -> Observable<PosterImage> {
        
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "path = %@", imagePath),
            NSPredicate(format: "width = %@", width)
        ])
        
        let result = withRealm("load") { realm -> PosterImageRealmObject in
            
        
            let objects = realm.objects(PosterImageRealmObject.self)
                                .filter(predicate)
            
            guard let object = objects.first else {
                throw DaoError.notFound
            }
            
            return object
        }
        
        switch result {
        case .success(let object):
            return .just(self.decode(object: object))
        case .failure(let error):
            return .error(error)
        }
    }
    
    func load(imagePath: String, width: Int) -> Observable<PosterImage?> {
        
        // TODO:
        return .just(nil)
        
    }
    
}
