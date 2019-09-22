//
//  MoviesQueryObject+Mapping.swift
//  MVVM
//
//  Created by Michal Ziobro on 22/09/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import CoreData

extension MoviesQueryObject {
    
    func encode(entity e: MoviesQuery) {
        self.id = e._identifier
        self.page = Int64(e.page)
        self.totalPages = Int64(e.totalPages)
        self.query = e.query
        
        e.results.forEach { movie in
            let o = MovieObject(context: self.managedObjectContext!)
            o.encode(entity: movie)
            self.addToResults(o)
        }
    }
       
    func decode() -> MoviesQuery {
        
        let results = Array(self.results ?? NSSet())
        let movies = results.map { $0 as! MovieObject }.map { $0.decode() }
        
        return MoviesQuery(query: self.query, page: Int(self.page), totalPages: Int(self.totalPages), results: movies)
    }
}


