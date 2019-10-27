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
    
    let storage : ICoreDataStorage
    
    init(storage: ICoreDataStorage = CoreDataStorage.shared) {
        self.storage = storage
    }
    
    func insert(_ e: Entity, completion: @escaping (Result<Entity, Error>) -> Void) {
        
        storage.persistentContainer.performBackgroundTask { [weak self] context in
            guard let self = self else { return }
           
            //let entityName = String(describing: ManagedObject.self)
            //let request = NSFetchRequest<ManagedObject>(entityName: entityName)
            let request = ManagedObject.fetchRequest() as! NSFetchRequest<ManagedObject>
            request.predicate = NSPredicate(format: "id = %@", e._identifier)
            
            do {
                let result = try context.fetch(request)
                
                if result.count == 0 {
                    // CREATE
                    var object = ManagedObject(context: context)
                    // var object = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context) as! ManagedObject
                    self.encode(entity: e, into: &object)
                    // let insertedObjectIds = [object.objectID]
                    self.storage.saveContext(context)
                    completion(.success(self.decode(object: object)))
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
       
    func insertReplacing(_ e: Entity, completion: @escaping (Result<Entity, Error>) -> Void) {
        
        storage.persistentContainer.performBackgroundTask { [weak self] context in
            guard let self = self else { return }
            
            let request = ManagedObject.fetchRequest() as! NSFetchRequest<ManagedObject>
            request.predicate = NSPredicate(format: "id = %@", e._identifier)
            
            do {
                let result = try context.fetch(request)
                
                if result.count == 0 {
                    // CREATE
                    var object = ManagedObject(context: context)
                    self.encode(entity: e, into: &object)
                    self.storage.saveContext(context)
                    completion(.success(self.decode(object: object)))
                } else if result.count > 1 {
                    completion(.failure(CoreDataError.inconsistentState))
                } else {
                    // REPLACE
                    context.delete(result.last!)
                    var object = ManagedObject(context: context)
                    self.encode(entity: e, into: &object)
                    self.storage.saveContext(context)
                    completion(.success(self.decode(object: object)))
                }
            } catch {
                completion(.failure(CoreDataError.readError(error)))
            }
        }
    }
       
    func delete(_ e: Entity, completion: @escaping (Result<Int, Error>) -> Void) {
        
        storage.persistentContainer.performBackgroundTask { [weak self] context in
            guard let self = self else { return }
            
            let request = ManagedObject.fetchRequest() as! NSFetchRequest<ManagedObject>
            request.predicate = NSPredicate(format: "id = %@", e._identifier)
            
            do {
                let result = try context.fetch(request)
            
                if let object = result.last {
                    guard result.count == 1 else { completion(.failure(CoreDataError.inconsistentState)) ; return }
                    context.delete(object)
                    self.storage.saveContext(context)
                    completion(.success(result.count))
                } else {
                    completion(.failure(DaoError.notFound))
                }
            } catch {
                completion(.failure(CoreDataError.readError(error)))
            }
        }
    }
       
    func update(_ e: Entity, completion: @escaping (Result<Entity, Error>) -> Void) {
        storage.persistentContainer.performBackgroundTask { [weak self] context in
            guard let self = self else { return }
            
            let request = ManagedObject.fetchRequest() as! NSFetchRequest<ManagedObject>
            request.predicate = NSPredicate(format: "id = %@", e._identifier)
            
            do {
                let result = try context.fetch(request)
                
                if var object = result.last {
                    guard result.count == 1 else { completion(.failure(CoreDataError.inconsistentState)) ; return }
                    
                    self.encode(entity: e, into: &object)
                    self.storage.saveContext(context)
                    completion(.success(self.decode(object: object)))
                } else {
                    completion(.failure(DaoError.notFound))
                }
            } catch {
                completion(.failure(CoreDataError.readError(error)))
            }
        }
    }
       
    func load(id: String, completion: @escaping (Result<Entity, Error>) -> Void) {
          
        storage.persistentContainer.performBackgroundTask { [weak self] context in
            guard let self = self else { return }
                      
            let request = ManagedObject.fetchRequest() as! NSFetchRequest<ManagedObject>
            request.predicate = NSPredicate(format: "id = %@", id)
                      
            do {
                let result = try context.fetch(request)
                          
                if let object = result.last {
                    guard result.count == 1 else { completion(.failure(CoreDataError.inconsistentState)) ; return }
                              
                    completion(.success(self.decode(object: object)))
                } else {
                    completion(.failure(DaoError.notFound))
                }
            } catch {
                completion(.failure(CoreDataError.readError(error)))
            }
        }
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
    
    
    // MARK: - OVERRIDABLE
    var sortDescriptors : [NSSortDescriptor]? {
        return nil
    }
    
    func encode(entity: Entity, into object: inout ManagedObject) -> Void {
        fatalError("no encoding provided between domain entity: \(String(describing: Entity.self)) and core data entity: \(String(describing: ManagedObject.self))")
    }
    
    func decode(object: ManagedObject) -> Entity {
        fatalError("no decoding provided between core data entity: \(String(describing: ManagedObject.self)) and domain entity: \(String(describing: Entity.self))")
    }
}
