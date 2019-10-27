//
//  MovieObject.swift
//  MVVM
//
//  Created by Michal Ziobro on 21/09/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation 
import CoreData

@objc(MovieObject)
public class MovieObject: NSManagedObject {

    @NSManaged var id: String
    @NSManaged var title: String
    @NSManaged var posterPath: String?
    @NSManaged var overview: String
    @NSManaged var releaseDate: String?
}

extension MovieObject {

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
