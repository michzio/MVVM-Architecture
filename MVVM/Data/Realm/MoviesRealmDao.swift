//
//  MoviesRealmDao.swift
//  MVVM
//
//  Created by Michal Ziobro on 27/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation

import RealmSwift 

class MoviesRealmDao : RealmDao<Movie, MovieRealmObject> {
    
    override func encode(entity e: Movie, into o: inout MovieRealmObject) {
        o.encode(entity: e)
    }
    
    override func decode(object o: MovieRealmObject) -> Movie {
        return o.decode()
    }
    
    override var sorting: ((MovieRealmObject, MovieRealmObject) -> Bool)? {
        return { o1, o2 in
            (o1.releaseDate ?? "") < (o2.releaseDate ?? "")
        }
    }
}

extension MoviesRealmDao : IMoviesDao {
    
    func load(query: String, completion: @escaping (Result<[Movie], Error>) -> Void) {
        
        let result = withRealm("load query") { realm -> [Movie] in
            
            let predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [
                NSPredicate(format: "title = %@", query),
                NSPredicate(format: "overview = %@", query)
            ])
            
            let objects = realm.objects(MovieRealmObject.self)
                                .filter(predicate)
            
            if let sorting = self.sorting {
                return objects.sorted(by: sorting).map { self.decode(object: $0) }
            } else {
                return objects.map { self.decode(object: $0) }
            }
        }
        
        completion(result)
    }
    
    func sync(movies: [Movie], completion: @escaping (Result<Bool, Error>) -> Void) {
        
        
        let result = withRealm("sync") { realm -> Bool in
            
            let objects : [MovieRealmObject] = movies.map {
                let o = MovieRealmObject()
                o.encode(entity: $0)
                return o
            }
            
            try realm.write {
                realm.add(objects, update: .modified)
            }
            
            return true
        }
        
        completion(result)
    }
}
