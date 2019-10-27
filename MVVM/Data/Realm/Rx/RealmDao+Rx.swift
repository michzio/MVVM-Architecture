//
//  RealmDao+Rx.swift
//  MVVM
//
//  Created by Michal Ziobro on 27/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation

import RxSwift

import RealmSwift
import RxRealm

extension RealmDao : IDao_Rx {
    
    func insert(_ e: Entity) -> Observable<Entity> {
        
        let result = withRealm("insert") { realm -> RealmObject in
            
            var object = RealmObject()
            self.encode(entity: e, into: &object)
            
            try realm.write {
                if realm.object(ofType: RealmObject.self, forPrimaryKey: e._identifier) != nil {
                    throw DaoError.insertionConflict
                }
                realm.add(object, update: .error)
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
    
    func insertReplacing(_ e: Entity) -> Observable<Entity> {
        
        let result = withRealm("insert replacing") { realm -> RealmObject in
            
            var object = RealmObject()
            self.encode(entity: e, into: &object)
            
            try realm.write {
                realm.add(object, update: .all)
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
    
    func delete(_ e: Entity) -> Observable<Int> {
        
        let result = withRealm("delete") { realm -> Int in
            
          guard let object = realm.object(ofType: RealmObject.self, forPrimaryKey: e._identifier) else {
                throw DaoError.notFound
            }
            
            try realm.write {
                realm.delete(object)
            }
            
            return 1
        }
        
        switch result {
        case .success(let deletedCount):
            return .just(deletedCount)
        case .failure(let error):
            return .error(error)
        }
        
        
    }
    
    func update(_ e: Entity) -> Observable<Entity> {
        
        let result = withRealm("update") { realm -> RealmObject in
            
            var object = RealmObject()
            self.encode(entity: e, into: &object)
            
            try realm.write {
                realm.add(object, update: .modified)
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
    
    func load(id: String) -> Observable<Entity> {
        
        let result = withRealm("load") { realm -> RealmObject in
        
            guard let object = realm.object(ofType: RealmObject.self, forPrimaryKey: id) else {
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
    
    func loadAll() -> Observable<[Entity]> {
        
        let result = withRealm("load all") { realm -> Results<RealmObject> in
            
            var objects = realm.objects(RealmObject.self)
                
            if let sort = sortKeyPath {
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
    
    // MARK: - OVERRIDABLE
    var sortKeyPath : (keyPath: String, ascending: Bool)? {
        return nil
    }
}
