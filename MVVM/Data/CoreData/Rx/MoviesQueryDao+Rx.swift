//
//  MoviesQueryDao+Rx.swift
//  MVVM
//
//  Created by Michal Ziobro on 27/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import CoreData

import RxSwift
import RxCoreData

extension MoviesQueryDao : IMoviesQueryDao_Rx {
    
    
    func load(query: String, page: Int) -> Observable<MoviesQuery> {
    
        let request : NSFetchRequest<MoviesQueryObject> = MoviesQueryObject.fetchRequest()
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "query = %@", query),
            NSPredicate(format: "page = %d", page)
        ])
        
        request.sortDescriptors = self.sortDescriptors ?? [NSSortDescriptor(key: "id", ascending: true)]
        
        return self.storage.taskContext.rx.entities(fetchRequest: request)
            .map { objects -> MoviesQuery in
                if let object = objects.first {
                    return self.decode(object: object)
                } else {
                    throw DaoError.notFound
                }
            }
    }
    
    func recent(number: Int) -> Observable<[MoviesQuery]> {
        
        let request : NSFetchRequest<MoviesQueryObject> = MoviesQueryObject.fetchRequest()
        request.fetchLimit = number
        
        // sort by insertion date
        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        
        return self.storage.taskContext.rx.entities(fetchRequest: request)
            .map { objects  -> [MoviesQuery] in
                objects.map { $0.decode() }
            }
    }
    
    func sync(moviesQuery: MoviesQuery) -> Observable<MoviesQuery> {
         
        return Observable.create { observer -> Disposable in
            
            self.storage.persistentContainer.performBackgroundTask { [weak self] context in
                guard let self = self else { observer.onCompleted(); return }
                
                let request : NSFetchRequest<MoviesQueryObject> = MoviesQueryObject.fetchRequest()
                
                request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
                    NSPredicate(format: "query = %@", moviesQuery.query ?? ""),
                    NSPredicate(format: "page = %d", moviesQuery.page)
                ])
                
                if var object = try? context.fetch(request).first {
                    // UPDATE
                    self.encode(entity: moviesQuery, into: &object)
                    self.storage.saveContext(context)
                    
                    observer.onNext(self.decode(object: object))
                } else {
                    // INSERT
                    var object = MoviesQueryObject(context: context)
                    self.encode(entity: moviesQuery, into: &object)
                    self.storage.saveContext(context)
                    
                    observer.onNext(self.decode(object: object))
                    observer.onCompleted()
                }
            }
            
            return Disposables.create()
        }
    }
    
    
    
}
