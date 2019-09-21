//
//  CoreDataDao.swift
//  MVVM
//
//  Created by Michal Ziobro on 21/09/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import CoreData

enum CoreDataError : Error {
    case readError(Error)
    case writeError(Error)
    case deleteError(Error)
    case inconsistentState
}

typealias CoreDataStorable = Identifiable

class CoreDataDao<T : CoreDataStorable, ManagedObject: NSManagedObject> : IDao {
   
    typealias Entity = T
    
    private let storage = CoreDataStorage.shared
    
    func insert(e: Entity, completion: @escaping (Result<Entity, Error>) -> Void) {
        
        storage.persistentContainer.performBackgroundTask { [weak self] context in
            guard let self = self else { return }
            
            let request = ManagedObject.fetchRequest()
            request.predicate = NSPredicate(format: "id = %@", e._identifier)
            
            do {
                let result = try context.fetch(request)
                
                if result.count == 0 {
                    // CREATE
                    _ = self.encode(entity: e, in: context)
                    self.storage.saveContext(context)
                } else if result.count > 1 {
                    completion(.failure(CoreDataError.inconsistentState))
                } else {
                    completion(.failure(DaoError.insertionConflict))
                }
            } catch {
                completion(.failure(CoreDataError.readError(error)))
            }
        }
    }
       
    func insertReplacing(e: Entity, completion: @escaping (Result<Entity, Error>) -> Void) {
        
    }
       
    func delete(e: Entity, completion: @escaping (Result<Int, Error>) -> Void) {
           
    }
       
    func update(e: Entity, completion: @escaping (Result<Entity, Error>) -> Void) {
           
    }
       
    func load(id: String, completion: @escaping (Result<Entity, Error>) -> Void) {
           
    }
       
    func loadAll(completion: @escaping (Result<[Entity], Error>) -> Void) {
        
        storage.persistentContainer.performBackgroundTask { [weak self] context in
            guard let self = self else { return }
            
            //let request = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: Entity.self))
            let request: NSFetchRequest<ManagedObject> = ManagedObject.fetchRequest() as! NSFetchRequest<ManagedObject>
            
            if let sortDescriptors = self.sortDescriptors {
                request.sortDescriptors = sortDescriptors
            }
            
            do {
                let result = try context.fetch(request).map { self.decode(object: $0) }
                
                DispatchQueue.global(qos: .background).async {
                    completion(.success(result))
                }
            } catch let error {
                DispatchQueue.global(qos: .background).async {
                    completion(.failure(CoreDataError.readError(error)))
                }
            }
        }
    }
    
    
    // MARK: - OVERRIDEBLE
    var sortDescriptors : [NSSortDescriptor]? {
        return nil
    }
    
    func encode(entity: Entity, in context: NSManagedObjectContext) -> ManagedObject {
        fatalError("no encoding provided between domain entity: \(String(describing: Entity.self)) and core data entity: \(String(describing: ManagedObject.self))")
    }
    
    func decode(object: ManagedObject) -> Entity {
        fatalError("no decoding provided between core data entity: \(String(describing: ManagedObject.self)) and domain entity: \(String(describing: Entity.self))")
    }
}
