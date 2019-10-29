//
//  ICoreDataStorage.swift
//  MVVM
//
//  Created by Michal Ziobro on 22/09/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import CoreData

public protocol ICoreDataStorage {
    
    var isInMemoryStore : Bool { get }
    
    var persistentContainer: NSPersistentContainer { get }
    
    var mainContext : NSManagedObjectContext { get }
    var taskContext : NSManagedObjectContext { get }
    func saveContext()
    func saveContext(_ context: NSManagedObjectContext)
    func saveContextAsync()
    func saveContextAsync(_ context: NSManagedObjectContext)
}

public extension ICoreDataStorage {
    
    var isInMemoryStore : Bool { return false }
    
    var mainContext : NSManagedObjectContext {
        return self.persistentContainer.viewContext
    }
    
    var taskContext : NSManagedObjectContext {
        
        let context = self.persistentContainer.newBackgroundContext()
        context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        context.undoManager = nil
        
        return context
    }
    
    // MARK: - Core Data Saving support

    func saveContextAsync() {
        let context = mainContext
        
        // Save all the changes just made and reset the context to free the cache.
        context.perform {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
            // Reset the context to clean up the cache and low the memory footprint.
            context.reset()
        }
    }
    
    func saveContext() {
        let context = mainContext
        
        // Save all the changes just made and reset the context to free the cache.
        context.performAndWait {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
            // Reset the context to clean up the cache and low the memory footprint.
            context.reset()
        }
    }
    
    func saveContextAsync(_ context: NSManagedObjectContext) {
        guard context != mainContext else {
            saveContext()
            return
        }
        
        
        context.perform {
            do {
                try context.save()
            } catch let error as NSError {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }

            self.saveContextAsync(self.mainContext)
        }
    }
    
    func saveContext(_ context: NSManagedObjectContext) {
        guard context != mainContext else {
            saveContext()
            return
        }
        
        context.performAndWait {
            do {
                try context.save()
            } catch let error as NSError {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }

            self.saveContext(self.mainContext)
        }
    }
}
