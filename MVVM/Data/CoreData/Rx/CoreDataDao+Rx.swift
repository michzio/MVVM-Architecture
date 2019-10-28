//
//  CoreDataDao+Rx.swift
//  MVVM
//
//  Created by Michal Ziobro on 27/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import CoreData

import RxSwift
import RxCoreData

extension CoreDataDao : IDao_Rx {
    
    
    func insert(_ e: Entity) -> Observable<Entity> {

        
       return Observable.create { observer -> Disposable in
            
         self.storage.persistentContainer.performBackgroundTask { [weak self] context in
                
            guard let self = self else { observer.onCompleted(); return }
                
                let request = ManagedObject.fetchRequest() as! NSFetchRequest<ManagedObject>
                request.predicate = NSPredicate(format: "id = %@", e._identifier)
                
                do {
                    let result = try context.fetch(request)
                    
                    if result.count == 0 {
                        // CREATE
                        var object = ManagedObject(context: context)
                        self.encode(entity: e, into: &object)
                        self.storage.saveContext(context)
                        
                        observer.onNext(self.decode(object: object))
                        observer.onCompleted()
                    } else if result.count > 1 {
                        return observer.onError(CoreDataError.inconsistentState)
                    } else {
                        return observer.onError(DaoError.insertionConflict)
                    }
                } catch {
                    return observer.onError(CoreDataError.readError(error))
                }
            }
        
            return Disposables.create()
        }
    }
    
    func insertReplacing(_ e: Entity) -> Observable<Entity> {
        
        return Observable.create { observer -> Disposable in
       
            self.storage.persistentContainer.performBackgroundTask { [weak self] context in
                
                guard let self = self else { observer.onCompleted(); return }
                
                let request = ManagedObject.fetchRequest() as! NSFetchRequest<ManagedObject>
                request.predicate = NSPredicate(format: "id = %@", e._identifier)
                
                do {
                    let result = try context.fetch(request)
                    
                    if result.count == 0 {
                        // CREATE
                        var object = ManagedObject(context: context)
                        self.encode(entity: e, into: &object)
                        self.storage.saveContext(context)
                        
                        observer.onNext(self.decode(object: object))
                        observer.onCompleted()
                    } else if result.count > 1 {
                        observer.onError(CoreDataError.inconsistentState)
                    } else {
                        // REPLACE
                        context.delete(result.last!)
                        
                        var object = ManagedObject(context: context)
                        self.encode(entity: e, into: &object)
                        self.storage.saveContext(context)
                        
                        observer.onNext(self.decode(object: object))
                        observer.onCompleted()
                    }
                } catch {
                    observer.onError(CoreDataError.readError(error))
                }
            }
        
            return Disposables.create()
        }
    }
    
    func delete(_ e: Entity) -> Observable<Int> {
        
        return Observable.create { observer -> Disposable in
            
            self.storage.persistentContainer.performBackgroundTask { [weak self] context in
                
                guard let self = self else { observer.onCompleted(); return }
                
                let request = ManagedObject.fetchRequest() as! NSFetchRequest<ManagedObject>
                request.predicate = NSPredicate(format: "id = %@", e._identifier)
                
                do {
                    let result = try context.fetch(request)
                    
                    if let object = result.last {
                        guard result.count == 1 else { observer.onError(CoreDataError.inconsistentState); return }
                        
                        context.delete(object)
                        self.storage.saveContext(context)
                        
                        observer.onNext(result.count)
                        observer.onCompleted()
                    } else {
                        observer.onError(DaoError.notFound)
                    }
                    
                } catch {
                    observer.onError(CoreDataError.readError(error))
                }
            }
            
            return Disposables.create()
        }
    }
    
    func update(_ e: Entity) -> Observable<Entity> {
        
        return Observable.create { observer -> Disposable in
            
            self.storage.persistentContainer.performBackgroundTask { [weak self] context in
                
                guard let self = self else { observer.onCompleted(); return }
                
                let request = ManagedObject.fetchRequest() as! NSFetchRequest<ManagedObject>
                request.predicate = NSPredicate(format: "id = %@", e._identifier)
                
                do {
                    
                    let result = try context.fetch(request)
                    
                    if var object = result.last {
                        guard result.count == 1 else { observer.onError(CoreDataError.inconsistentState); return }
                        
                        self.encode(entity: e, into: &object)
                        self.storage.saveContext(context)
                        
                        observer.onNext(self.decode(object: object))
                        observer.onCompleted()
                        
                    } else {
                        observer.onError(DaoError.notFound)
                    }
                    
                } catch {
                    observer.onError(CoreDataError.readError(error))
                }
            }
            
            return Disposables.create()
        }
    }
    
    func load(id: String) -> Observable<Entity> {
        
        let request = ManagedObject.fetchRequest() as! NSFetchRequest<ManagedObject>
        request.predicate = NSPredicate(format: "id = %@", id)
        
        request.sortDescriptors = self.sortDescriptors ?? [NSSortDescriptor(key: "id", ascending: true)]
        
        return self.storage.taskContext.rx.entities(fetchRequest: request)
            .map { objects -> Entity in
                if let object = objects.first {
                    guard objects.count == 1 else {
                        throw CoreDataError.inconsistentState
                    }
                    return self.decode(object: object)
                } else {
                    throw DaoError.notFound
                }
            }
    }
    
    func loadAll() -> Observable<[Entity]> {
        
        let request = ManagedObject.fetchRequest() as! NSFetchRequest<ManagedObject>
        
        if let sortDescriptors = self.sortDescriptors {
            request.sortDescriptors = sortDescriptors
        }
        
        return self.storage.taskContext.rx.entities(fetchRequest: request)
            .map { objects -> [Entity] in
                objects.map { self.decode(object: $0) }
        }
    }
}
