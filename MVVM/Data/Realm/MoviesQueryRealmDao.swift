//
//  File.swift
//  MVVM
//
//  Created by Michal Ziobro on 27/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation

import RealmSwift

class MoviesQueryRealmDao : RealmDao<MoviesQuery, MoviesQueryRealmObject> {
    
    override func encode(entity e: MoviesQuery, into o: inout MoviesQueryRealmObject) {
        o.encode(entity: e)
    }
    
    override func decode(object o: MoviesQueryRealmObject) -> MoviesQuery {
        return o.decode()
    }
}

extension MoviesQueryRealmDao : IMoviesQueryDao {
    
    func load(query: String, page: Int, completion: @escaping (Result<MoviesQuery, Error>) -> Void) {
        
        let result = withRealm("load query/page") { realm -> MoviesQuery in
            
            let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
                    NSPredicate(format: "query = %@", query),
                    NSPredicate(format: "page = %@", page)
            ])
            
            let objects = realm.objects(MoviesQueryRealmObject.self).filter(predicate)
            
            guard let object = objects.first else {
                throw DaoError.notFound
            }
            
            return self.decode(object: object)
        }
        
        completion(result)
    }
    
    func recent(number: Int, completion: @escaping (Result<[MoviesQuery], Error>) -> Void) {
        
        let result = withRealm("recent") { realm -> [MoviesQuery] in
            
            let objects = realm.objects(MoviesQueryRealmObject.self)
                .sorted(byKeyPath: "createdAt", ascending: false)
        
            var queries = [MoviesQuery]()
            for i in 0..<number {
                let o = objects[i]
                let query = self.decode(object: o)
                queries.append(query)
            }
            return queries
        }
        
        completion(result)
    }
    
    func sync(moviesQuery: MoviesQuery, completion: @escaping (Result<MoviesQuery, Error>) -> Void) {
        
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "query = %@", moviesQuery.query ?? ""),
            NSPredicate(format: "page = %@", moviesQuery.page)
        ])
        
        let result = withRealm("sync") { realm -> MoviesQuery in
            
            if var object = realm.objects(MoviesQueryRealmObject.self)
                                .filter(predicate).first {
                // UPDATE
                self.encode(entity: moviesQuery, into: &object)
                
                try realm.write {
                    realm.add(object, update: .modified)
                }
                return self.decode(object: object)
            } else {
                // INSERT
                var object = MoviesQueryRealmObject()
                self.encode(entity: moviesQuery, into: &object)
                
                try realm.write {
                    realm.add(object, update: .error)
                }
                
                return self.decode(object: object)
            }
        }
        
        completion(result)
    }
}
