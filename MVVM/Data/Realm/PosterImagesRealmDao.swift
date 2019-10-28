//
//  File.swift
//  MVVM
//
//  Created by Michal Ziobro on 27/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation

import RealmSwift

class PosterImagesRealmDao : RealmDao<PosterImage, PosterImageRealmObject> {
    
    override func encode(entity e: PosterImage, into o: inout PosterImageRealmObject) {
        o.encode(entity: e)
    }
    
    override func decode(object o: PosterImageRealmObject) -> PosterImage {
        return o.decode()
    }
}

extension PosterImagesRealmDao : IPosterImagesDao {
    
    func load(imagePath: String, width: Int, completion: @escaping (Result<PosterImage, Error>) -> Void) {
        
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "path = %@", imagePath),
            NSPredicate(format: "width = %d", width)
        ])
        
        let result = withRealm("load") { realm -> PosterImage in
            
            let objects = realm.objects(PosterImageRealmObject.self)
                                .filter(predicate)
            
            guard let object = objects.first else {
                throw DaoError.notFound
            }
            
            return self.decode(object: object)
        }
        
        completion(result)
    }
}
