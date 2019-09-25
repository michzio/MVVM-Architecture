//
//  MoviesQueryObject+Mapping.swift
//  MVVM
//
//  Created by Michal Ziobro on 22/09/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import CoreData

extension MoviesQueryObject {
    
    public override func awakeFromInsert() {
        self.createdAt = Date()
    }
    
    func encode(entity e: MoviesQuery) {
        self.id = e._identifier
        self.page = Int64(e.page)
        self.totalPages = Int64(e.totalPages)
        self.query = e.query
        
        
        let ids = e.results.map { $0._identifier }
        let request = MovieObject.fetchRequest()
        request.predicate = NSPredicate(format: "id in %@", ids)
        
        let existing = (try? request.execute() as? [MovieObject]) ?? []
        
        let toUpdate = e.results.filter {
            existing.map { $0.id }.contains($0._identifier)
        }.map { movie in
            (movie, existing.first(where: { $0.id == movie._identifier })!)
        }
        
        let toInsert = e.results.filter {
            !existing.map { $0.id }.contains($0._identifier)
        }
        
        let toRemove = self.results?
            .map { $0 as! MovieObject }
            .filter {
                let o = $0 as! MovieObject
                return ids.contains(o.id) == false
            }
    
        toInsert.forEach { movie in
            let o = MovieObject(context: self.managedObjectContext!)
            o.encode(entity: movie)
            self.addToResults(o)
        }
        
        toUpdate.forEach {
            let (m, o) = $0
            o.encode(entity: m)
            self.addToResults(o)
        }
        
        toRemove?.forEach {
            self.removeFromResults($0)
        }
    }
       
    func decode() -> MoviesQuery {
        
        let results = Array(self.results ?? NSSet())
        let movies = results.map { $0 as! MovieObject }.map { $0.decode() }
        
        return MoviesQuery(query: self.query, page: Int(self.page), totalPages: Int(self.totalPages), results: movies)
    }
}


