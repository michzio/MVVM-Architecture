//
//  File.swift
//  MVVM
//
//  Created by Michal Ziobro on 27/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation

import RxSwift

import RealmSwift
import RxRealm

extension MoviesQueryRealmDao : IMoviesQueryDao_Rx {
    
    func load(query: String, page: Int) -> Observable<MoviesQuery> {
        
        let result = withRealm("load") { realm -> MoviesQueryRealmObject in
            
            let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
                NSPredicate(format: "query = %@", query),
                NSPredicate(format: "page = %@", page)
            ])
            
            let objects = realm.objects(MoviesQueryRealmObject.self)
                            .filter(predicate)
            guard let object = objects.first else {
                throw DaoError.notFound
            }
            
            return object
        }
        
        
        switch result {
        case .success(let object):
            return .just(self.decode(object: object))
        case .failure(let error):
            return .error(error)
        }
    }
    
    func load(query: String, page: Int) -> Observable<MoviesQuery?> {
        
        let result = withRealm("load") { realm -> MoviesQueryRealmObject in
            
            let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
                NSPredicate(format: "query = %@", query),
                NSPredicate(format: "page = %@", page)
            ])
            
            let objects = realm.objects(MoviesQueryRealmObject.self)
                            .filter(predicate)
            guard let object = objects.first else {
                throw DaoError.notFound
            }
            
            return object
        }
        
        switch result {
        case .success(let object):
            return .just(self.decode(object: object))
        case .failure:
            return .just(nil)
        }
    }
    
    func recent(number: Int) -> Observable<[MoviesQuery]> {
        
        let result = withRealm("recent") { realm -> Results<MoviesQueryRealmObject> in
            
            let objects = realm.objects(MoviesQueryRealmObject.self)
                    .sorted(byKeyPath: "createdAt", ascending: false)
            
            return objects
        }
        
        switch result {
        case .success(let objects):
            return Observable.array(from: objects)
                .map {
                    $0.prefix(number).map {
                        self.decode(object: $0)
                    }
            }
        case .failure(let error):
            return .error(error)
        }
    }
    
    func sync(moviesQuery: MoviesQuery) -> Observable<MoviesQuery> {
        
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "query = %@", moviesQuery.query ?? ""),
            NSPredicate(format: "page = %@", moviesQuery.page)
        ])
        
        let result = withRealm("sync") { realm -> MoviesQueryRealmObject in
            
            if var object = realm.objects(MoviesQueryRealmObject.self).filter(predicate).first {
                // UPDATE
                self.encode(entity: moviesQuery, into: &object)
                
                try realm.write {
                    realm.add(object, update: .modified)
                }
                
                return object
            } else {
                // INSERT
                var object = MoviesQueryRealmObject()
                self.encode(entity: moviesQuery, into: &object)
                
                try realm.write {
                    realm.add(object, update: .error)
                }
                
                return object
            }
        }
        
        switch result {
        case .success(let object):
            return .just(self.decode(object: object))
        case .failure(let error):
            return .error(error)
        }
    }
    
    
    
}

