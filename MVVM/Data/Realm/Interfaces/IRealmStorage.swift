//
//  IRealmStorage.swift
//  MVVM
//
//  Created by Michal Ziobro on 26/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation
import RealmSwift

public protocol IRealmStorage {
    //associatedtype Entity
    
    func withRealm<Entity>(_ operation: String, action: (Realm) throws -> Entity) -> Result<Entity, Error>
}

public extension IRealmStorage {
    func withRealm<Entity>(_ operation: String, action: (Realm) throws -> Entity) -> Result<Entity, Error> {
        
        do {
            let realm = try Realm()
            let entity = try action(realm)
            return .success(entity)
        } catch let err {
            print("Failed realm \(operation) with error: \(err)")
            return .failure(err)
        }
    }
}
