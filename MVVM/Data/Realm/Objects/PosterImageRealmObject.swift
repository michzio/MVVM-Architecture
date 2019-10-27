//
//  PosterImageObject+RealmModel.swift
//  MVVM
//
//  Created by Michal Ziobro on 26/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation
import RealmSwift

public class PosterImageRealmObject: Object {
    @objc dynamic var id = ""
    @objc dynamic var path = ""
    @objc dynamic var data : Data = Data()
    @objc dynamic var width: Int32 = 0
    
    public override class func primaryKey() -> String? {
        return "id"
    }
    
    // Relationships
    @objc dynamic var movie : MovieRealmObject!
}

extension PosterImageRealmObject {
    
    func encode(entity e: PosterImage) {
        self.id = e._identifier
        self.path = e.path
        self.data = e.data
        self.width = Int32(e.width)
        
        let realm = try! Realm()
        let predicate = NSPredicate(format: "posterPath = %@", e.path)
        self.movie = realm.objects(MovieRealmObject.self).filter(predicate).first
    }
    
    func decode() -> PosterImage {
        
        return PosterImage(path: self.path, width: Int(self.width), data: self.data)
    }
}
