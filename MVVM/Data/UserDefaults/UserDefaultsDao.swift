//
//  UserDefaultsDao.swift
//  MVVM
//
//  Created by Michal Ziobro on 21/09/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation

class UserDefaultsDao<T : UserDefaultsStorable> : IDao {
    
    typealias Entity = T
    
    let storage = UserDefaultsStorage<Entity>()
   
    func insert(e: Entity, completion: @escaping (Result<Entity, Error>) -> Void) {
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            
            var entities = self.storage.entities
            if entities.contains(e) {
                completion(.failure(DaoError.insertionConflict))
            }
            entities.insert(e, at: 0)
            
            self.storage.entities = entities
            
            completion(.success(e))
        }
    }
    
    func insertReplacing(e: T, completion: @escaping (Result<T, Error>) -> Void) {
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            
            var entities = self.storage.entities
            
            entities = entities.filter { $0 != e }
            entities.insert(e, at: 0)
            
            self.storage.entities = entities
            completion(.success(e))
        }
    }
       
    func delete(e: Entity, completion: @escaping (Result<Int, Error>) -> Void) {
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            
            var entities = self.storage.entities
            let beforeCount = entities.count
            entities.removeAll { $0 == e }
            let afterCount = entities.count
            
            self.storage.entities = entities
            completion(.success(beforeCount - afterCount))
        }
        
    }
       
    func update(e: Entity, completion: @escaping (Result<Entity, Error>) -> Void) {
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            
            var entities = self.storage.entities
            
            if let index = entities.firstIndex(of: e) {
                entities[index] = e
                self.storage.entities = entities
                completion(.success(e))
            } else {
                completion(.failure(DaoError.notFound))
            }
        }
    }

    func load(id: String, completion: @escaping (Result<Entity, Error>) -> Void) {
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            
            if let entity = self.storage.entities.first(where: { $0._identifier == id }) {
                completion(.success(entity))
            } else {
                completion(.failure(DaoError.notFound))
            }
        }
    }
       
    func loadAll(completion: @escaping (Result<[Entity], Error>) -> Void) {
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            
            let entities = self.storage.entities
            completion(.success(entities))
            
        }
        
    }
}
