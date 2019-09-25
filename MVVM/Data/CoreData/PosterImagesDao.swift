//
//  PosterImagesDao.swift
//  MVVM
//
//  Created by Michal Ziobro on 25/09/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import CoreData

class PosterImagesDao : CoreDataDao<PosterImage, PosterImageObject> {
    
    override func encode(entity e: PosterImage, into o: inout PosterImageObject) {
        o.encode(entity: e)
    }
    
    override func decode(object o: PosterImageObject) -> PosterImage {
        return o.decode()
    }
}

extension PosterImagesDao : IPosterImagesDao {
    
    func load(imagePath: String, width: Int, completion: @escaping (Result<PosterImage, Error>) -> Void) {
        
        self.storage.persistentContainer.performBackgroundTask { [weak self] context in
            guard let self = self else { return }
            
            let request : NSFetchRequest<PosterImageObject> = PosterImageObject.fetchRequest()
            
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
                NSPredicate(format: "path = %@", imagePath),
                NSPredicate(format: "width = %d", width)
            ])
            
            do {
                if let result = try context.fetch(request).first {
                    completion(.success(self.decode(object: result)))
                } else {
                    completion(.failure(DaoError.notFound))
                }
            } catch {
                completion(.failure(CoreDataError.readError(error)))
            }
        }
    }
    
}
