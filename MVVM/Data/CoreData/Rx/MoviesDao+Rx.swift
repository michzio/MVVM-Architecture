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
            NSPredicate(format: "title = %@", query),
            NSPredicate(format: "overview = %@", query)
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
                
                let ids = movies.map(\.id)
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
                    observer.onError(CoreDataError.deleteError(error))
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
