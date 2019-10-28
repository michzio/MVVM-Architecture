//
//  MoviesDao.swift
//  MVVM
//
//  Created by Michal Ziobro on 21/09/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import CoreData
import RxSwift

class MoviesDao : CoreDataDao<Movie, MovieObject> {
    
    override func encode(entity e: Movie, into o: inout MovieObject) {
        o.encode(entity: e)
    }
    
    override func decode(object o: MovieObject) -> Movie {
        return o.decode()
    }
    
    override var sortDescriptors: [NSSortDescriptor]? {
        return [
            NSSortDescriptor(keyPath: \MovieObject.releaseDate, ascending: true)
        ]
    }
}

extension MoviesDao : IMoviesDao {
    
    func load(query: String, completion: @escaping (Result<[Movie], Error>) -> Void) {
        self.storage.persistentContainer.performBackgroundTask { [weak self] context in
            guard let self = self else { return }
            
            let request : NSFetchRequest<MovieObject> = MovieObject.fetchRequest() as! NSFetchRequest<MovieObject>
            request.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [
                NSPredicate(format: "title = %@", query),
                NSPredicate(format: "overview = %@", query)
            ])
            
            if let sortDescriptors = self.sortDescriptors {
                request.sortDescriptors = sortDescriptors
            }
            
            do {
                let result = try context.fetch(request).map { self.decode(object: $0)}
                
                completion(.success(result))
            } catch {
                completion(.failure(CoreDataError.readError(error)))
            }
            
        }
    }
    
    func sync(movies: [Movie], completion: @escaping (Result<Bool, Error>) -> Void) {
        self.storage.persistentContainer.performBackgroundTask { [weak self] context in
            guard let self = self else { return }
            
            let request = MovieObject.fetchRequest()
            
            let ids = movies.map { "\($0.id)" }
            request.predicate = NSPredicate(format: "id in %@", ids)
            
            let batchDelete = NSBatchDeleteRequest(fetchRequest: request)
            batchDelete.resultType = .resultTypeObjectIDs
            
            // execute the batch delete request and merge the changes to viewContext
            do {
                let result = try context.execute(batchDelete) as? NSBatchDeleteResult
                
                if let deletedObjectIds = result?.result as? [NSManagedObjectID] {
                    NSManagedObjectContext.mergeChanges(fromRemoteContextSave: [NSDeletedObjectsKey: deletedObjectIds], into: [self.storage.persistentContainer.viewContext])
                }
            } catch {
                completion(.failure(CoreDataError.deleteError(error)))
            }
            
            // create new records
            for movie in movies {
                var object = MovieObject(context: context)
                self.encode(entity: movie, into: &object)
                self.storage.saveContext(context)
            }
            
            completion(.success(true))
        }
    }
    
    // alternative solution (if there are conflicts entities should be updated keeping relationships)
    // but here there can be need to adjust entities to dicts mapping to have matching keys
    // it is also important to have id key unique to force object update on conflict
    func _sync(movies: [Movie], completion: @escaping (Result<Bool, Error>) -> Void) {
        
        let objects = movies.compactMap { $0.dict }
        
        self.storage.persistentContainer.performBackgroundTask { context in
         
            let batchInsert = NSBatchInsertRequest(entity: MovieObject.entity(), objects: objects)
            do {
                let result = try context.execute(batchInsert) as! NSBatchInsertResult
                let success = result.result as! Bool
                
                completion(.success(success))
            } catch {
                completion(.failure(CoreDataError.writeError(error)))
            }
        }
    }
}
