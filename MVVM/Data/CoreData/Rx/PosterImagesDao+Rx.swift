//
//  PosterImagesDao+Rx.swift
//  MVVM
//
//  Created by Michal Ziobro on 27/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import CoreData

import RxSwift
import RxCocoa

extension PosterImagesDao : IPosterImagesDao_Rx {
    
    func load(imagePath: String, width: Int) -> Observable<PosterImage> {
        
        let request : NSFetchRequest<PosterImageObject> = PosterImageObject.fetchRequest()
        
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "path = %@", imagePath),
            NSPredicate(format: "width = %d", width)
        ])
        
        request.sortDescriptors = [NSSortDescriptor(key: "path", ascending: true)]
        
        return self.storage.taskContext.rx.entities(fetchRequest: request)
            .map { objects -> PosterImage in
                if let object = objects.first {
                    return object.decode()
                } else {
                    throw DaoError.notFound
                }
            }
    }
    
    func load(imagePath: String, width: Int) -> Observable<PosterImage?> {
        
        let request : NSFetchRequest<PosterImageObject> = PosterImageObject.fetchRequest()
        
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "path = %@", imagePath),
            NSPredicate(format: "width = %d", width)
        ])
        
        request.sortDescriptors = [NSSortDescriptor(key: "path", ascending: true)]
        
        return self.storage.taskContext.rx.entities(fetchRequest: request)
            .map { objects -> PosterImage? in
                if let object = objects.first {
                    return object.decode()
                } else {
                    return nil
                }
            }
    }
}

 
