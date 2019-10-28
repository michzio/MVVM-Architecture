//
//  MoviesQueryDao.swift
//  MVVM
//
//  Created by Michal Ziobro on 22/09/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import CoreData

class MoviesQueryDao : CoreDataDao<MoviesQuery, MoviesQueryObject> {

    override func encode(entity e: MoviesQuery, into o: inout MoviesQueryObject) {
        o.encode(entity: e)
    }
    
    override func decode(object o: MoviesQueryObject) -> MoviesQuery {
        return o.decode()
    }
}

extension MoviesQueryDao : IMoviesQueryDao {
        
    func load(query: String, page: Int, completion: @escaping (Result<MoviesQuery, Error>) -> Void) {
        
        self.storage.persistentContainer.performBackgroundTask { [weak self] context in
                  guard let self = self else { return }
                  
                  let request : NSFetchRequest<MoviesQueryObject> = MoviesQueryObject.fetchRequest()
                  request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
                      NSPredicate(format: "query = %@", query),
                      NSPredicate(format: "page = %d", page)
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
    
    func recent(number: Int, completion: @escaping (Result<[MoviesQuery], Error>) -> Void) {
        
        self.storage.persistentContainer.performBackgroundTask { [weak self] context in
            guard let self = self else { return }
            
            let request : NSFetchRequest<MoviesQueryObject> = MoviesQueryObject.fetchRequest()
            
            request.fetchLimit = number
            
            // sort by insertion date
            request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
            
            do {
                let objects = try context.fetch(request)
                let queries = objects.map { self.decode(object: $0) }
                
                completion(.success(queries))
            } catch {
                completion(.failure(CoreDataError.readError(error)))
            }
        }
    }
    
    func sync(moviesQuery: MoviesQuery, completion: @escaping (Result<MoviesQuery, Error>) -> Void) {
        
        self.storage.persistentContainer.performBackgroundTask { [weak self] context in
            guard let self = self else { return }
            
            let request : NSFetchRequest<MoviesQueryObject> = MoviesQueryObject.fetchRequest()
            
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
                NSPredicate(format: "query = %@", moviesQuery.query ?? ""),
                NSPredicate(format: "page = %d", moviesQuery.page)
            ])
            
            
            if var object = try? context.fetch(request).first {
                // UPDATE
                self.encode(entity: moviesQuery, into: &object)
                self.storage.saveContext(context)
                
                completion(.success(self.decode(object: object)))
            } else {
                // INSERT
                var object = MoviesQueryObject(context: context)
                self.encode(entity: moviesQuery, into: &object)
                self.storage.saveContext(context)
                
                completion(.success(self.decode(object: object)))
            }
        }
    }

}
