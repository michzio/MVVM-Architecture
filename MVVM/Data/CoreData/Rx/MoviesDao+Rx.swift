//
//  MoviesDao+Rx.swift
//  MVVM
//
//  Created by Michal Ziobro on 27/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import CoreData

import RxSwift
import RxCoreData

extension MoviesDao : IMoviesDao_Rx {
    
    func load(query: String) -> Observable<[Movie]> {
        
        let request = MovieObject.fetchRequest() as! NSFetchRequest<MovieObject>
        request.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [
            NSPredicate(format: "title CONTAINS[cd] %@", query),
            NSPredicate(format: "overview CONTAINS[cd] %@", query)
        ])
        
        if let sortDescriptors = self.sortDescriptors {
            request.sortDescriptors = sortDescriptors
        }
        
        return self.storage.taskContext.rx.entities(fetchRequest: request)
            .map { objects -> [Movie] in
                objects.map { $0.decode() }
            }
    }
    
    func sync(movies: [Movie]) -> Observable<Bool> {
        
        return Observable.create { observer -> Disposable in
            
            self.storage.persistentContainer.performBackgroundTask { [weak self] context in
             
                guard let self = self else { observer.onCompleted(); return }
                
                let request = MovieObject.fetchRequest()
                
                let ids = movies.map { "\($0.id)" }
                request.predicate = NSPredicate(format: "id in %@", ids)
                
                if self.storage.isInMemoryStore {
                    do {
                        let result : [MovieObject] = try context.fetch(request) as! [MovieObject]
                        
                        for object in result {
                            context.delete(object)
                        }
                        
                    } catch {
                        observer.onError(CoreDataError.deleteError(error))
                    }
                } else {
                    let batchDelete = NSBatchDeleteRequest(fetchRequest: request)
                    batchDelete.resultType = .resultTypeObjectIDs
                    
                    // execute the batch delete request and merge the changes to viewContext
                    do {
                        let result = try context.execute(batchDelete) as? NSBatchDeleteResult
                        
                        if let deletedObjectIds = result?.result as? [NSManagedObjectID] {
                            NSManagedObjectContext.mergeChanges(fromRemoteContextSave: [NSDeletedObjectsKey: deletedObjectIds], into: [self.storage.persistentContainer.viewContext])
                        }
                    } catch {
                        observer.onError(CoreDataError.deleteError(error))
                    }
                }
                
                // create new records
                for movie in movies {
                    var object = MovieObject(context: context)
                    self.encode(entity: movie, into: &object)
                    self.storage.saveContext(context)
                }
                
                observer.onNext(true)
                observer.onCompleted()
            }
            
            return Disposables.create()
        }
    }
    
}
