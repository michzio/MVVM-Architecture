//
//  UserDefaultsStorage.swift
//  MVVM
//
//  Created by Michal Ziobro on 21/09/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation

typealias UserDefaultsStorable = Codable & Hashable & Identifiable

final class UserDefaultsStorage<Entity : UserDefaultsStorable> {
    
    private var userDefaults: UserDefaults { return UserDefaults.standard }
    private var key: String {
        return String(describing: Entity.self) + "UserDefaultsStorage"
    }
    
    init() { }
    
    var entities: [Entity] {
        get {
            guard let data = userDefaults.object(forKey: key) as? Data else { return [] }
            let decoder = JSONDecoder()
            guard let entities = try? decoder.decode([Entity].self, from: data) else { return [] }
            return entities
        }
        set {
            let encoder = JSONEncoder()
            guard let data = try? encoder.encode(newValue) else { return }
            userDefaults.set(data, forKey: key)
        }
    }
}
