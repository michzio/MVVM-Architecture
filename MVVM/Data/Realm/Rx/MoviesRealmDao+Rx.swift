//
//  MoviesRealmDao+Rx.swift
//  MVVM
//
//  Created by Michal Ziobro on 27/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation

import RxSwift

import RealmSwift
import RxRealm

extension MoviesRealmDao : IMoviesDao_Rx {
    
    func load(query: String) -> Observable<[Movie]> {
        
        let result = withRealm("load query") { realm -> Results<MovieRealmObject> in
            
            let predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [
                NSPredicate(format: "title = %@", query),
                NSPredicate(format: "overview = %@", query)
            ])
            
            var objects = realm.objects(MovieRealmObject.self).filter(predicate)
            
            if let sort = self.sortKeyPath {
                objects = objects.sorted(byKeyPath: sort.keyPath, ascending: sort.ascending)
            }
            
            return objects
        }
        
        switch result {
        case .success(let objects):
            return Observable.array(from: objects)
                        .map {
                            $0.map { self.decode(object: $0) }
                        }
        case .failure(let error):
            return .error(error)
        }
    }
    
    func sync(movies: [Movie]) -> Observable<Bool> {
        
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
        
        switch result {
        case .success:
            return .just(true)
        case .failure(let error):
            return .error(error)
        }
    }
    
    

}
