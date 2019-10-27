//
//  RealmDao.swift
//  MVVM
//
//  Created by Michal Ziobro on 26/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation

import RealmSwift

typealias RealmStorable = Identifiable

class RealmDao<T: RealmStorable, RealmObject : Object> : IDao {
    
    typealias Entity = T
    
    let storage : IRealmStorage
    
    init(storage: IRealmStorage = RealmStorage.shared) {
        self.storage = storage
    }
    
    func insert(_ e: Entity, completion: @escaping (Result<Entity, Error>) -> Void) {
        
        let result = withRealm("insert") { realm throws -> Entity in
            
            var object = RealmObject()
            self.encode(entity: e, into: &object)
           
            try realm.write {
                if realm.object(ofType: RealmObject.self, forPrimaryKey: e._identifier) != nil {
                    throw DaoError.insertionConflict
                }
                realm.add(object, update: .error)
            }
            
            return self.decode(object: object)
        }
        
        completion(result)
    }
    
    func insertReplacing(_ e: Entity, completion: @escaping (Result<Entity, Error>) -> Void) {
        
        let result = withRealm("insert replacing") { realm -> Entity in
            
            var object = RealmObject()
            self.encode(entity: e, into: &object)
            
            try realm.write {
                realm.add(object, update: .all)
            }
    
            return self.decode(object: object)
        }
        
        completion(result)
    }
    
    func delete(_ e: Entity, completion: @escaping (Result<Int, Error>) -> Void) {
        
        let result = withRealm("delete") { realm -> Int in
            
            guard let object = realm.object(ofType: RealmObject.self, forPrimaryKey: e._identifier) else {
                throw DaoError.notFound
            }
            
            try realm.write {
                realm.delete(object)
            }
            
            return 1
        }
        
        completion(result)
    }
    
    func update(_ e: Entity, completion: @escaping (Result<Entity, Error>) -> Void) {
        
        let result = withRealm("update") { realm -> Entity in
            
            var object = RealmObject()
            self.encode(entity: e, into: &object)
            
            try realm.write {
                realm.add(object, update: .modified)
            }
            
            return self.decode(object: object)
        }
        
        completion(result)
    }
    
    func load(id: String, completion: @escaping (Result<Entity, Error>) -> Void) {
        
        let result = withRealm("load") { realm -> Entity in
            guard let object =  realm.object(ofType: RealmObject.self, forPrimaryKey: id) else {
                throw DaoError.notFound
            }
            return self.decode(object: object)
        }
        
        completion(result)
    }
    
    func loadAll(completion: @escaping (Result<[Entity], Error>) -> Void) {
        
        let result = withRealm("load all") { realm -> [Entity] in
            let objects = realm.objects(RealmObject.self)
            
            if let sorting = self.sorting {
                return objects.sorted(by: sorting).map { self.decode(object: $0) }
            } else {
                return objects.map { self.decode(object: $0) }
            }
        }
        
        completion(result)
    }

    // MARK: - OVERRIDABLE
    var sorting : ((RealmObject, RealmObject) -> Bool)? {
        return nil
    }
    
    func encode(entity: Entity, into object: inout RealmObject) -> Void {
        fatalError("no encoding provided between domain entity: \(String(describing: Entity.self)) and Realm entity: \(String(describing: RealmObject.self))")
    }
    
    func decode(object: RealmObject) -> Entity {
        fatalError("no decoding provided between Realm enity: \(String(describing: RealmObject.self)) and domain entity: \(String(describing: Entity.self))")
    }
    
    // MARK: - Helpers
    func withRealm<Entity>(_ operation: String, action: (Realm) throws -> Entity) -> Result<Entity, Error> {
       
        return self.storage.withRealm(operation, action: action)
    }
}
