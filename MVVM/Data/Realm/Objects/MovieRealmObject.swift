//
//  MovieObject.swift
//  MVVM
//
//  Created by Michal Ziobro on 26/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation
import RealmSwift

public class MovieRealmObject: Object {
       @objc dynamic var id = ""
       @objc dynamic var title = ""
       @objc dynamic var posterPath: String?
       @objc dynamic var overview = ""
       @objc dynamic var releaseDate: String?
       
       override public static func primaryKey() -> String? {
           return "id"
       }
       
       // Relationships
       var queries = List<MoviesQueryRealmObject>()
       var images = List<PosterImageRealmObject>()
}

extension MovieRealmObject {
    func encode(entity e: Movie) {
        self.id = e._identifier
        self.title = e.title
        self.posterPath = e.posterPath
        self.overview = e.overview
        self.releaseDate = e.releaseDate
    }
    
    func decode() -> Movie {
        return Movie(id: Int(self.id)!, title: self.title, posterPath: self.posterPath, overview: self.overview, releaseDate: self.releaseDate)
    }
}
