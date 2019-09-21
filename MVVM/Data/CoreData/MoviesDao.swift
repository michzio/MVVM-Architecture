//
//  MoviesDao.swift
//  MVVM
//
//  Created by Michal Ziobro on 21/09/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import CoreData

class MoviesDao : CoreDataDao<Movie, MovieObject> {
    
    override func encode(entity e: Movie, in context: NSManagedObjectContext) -> MovieObject {
        
        let o = MovieObject(context: context)
        o.id = "\(e.id)"
        o.title = e.title
        o.posterPath = e.posterPath
        o.overview = e.overview
        o.releaseDate = e.releaseDate
        return o
    }
    
    override func decode(object o: MovieObject) -> Movie {
        
        return Movie(id: Int(o.id)!, title: o.title, posterPath: o.posterPath, overview: o.overview, releaseDate: o.releaseDate)
    }
    
    override var sortDescriptors: [NSSortDescriptor]? {
        return [
            NSSortDescriptor(keyPath: \MovieObject.releaseDate, ascending: true)
        ]
    }
}

