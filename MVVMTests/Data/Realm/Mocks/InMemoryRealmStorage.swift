//
//  InMemoryRealmStorage.swift
//  MVVMTests
//
//  Created by Michal Ziobro on 27/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import RealmSwift
import MVVM

class InMemoryRealmStorage : IRealmStorage {
    
    func useCleanMemoryRealmByDefault(identifier: String = "memory") {
           var config = Realm.Configuration.defaultConfiguration
           config.inMemoryIdentifier = identifier
           config.deleteRealmIfMigrationNeeded = true
           Realm.Configuration.defaultConfiguration = config
           
           let realm = try! Realm()
           try! realm.write(realm.deleteAll)
    }
}
