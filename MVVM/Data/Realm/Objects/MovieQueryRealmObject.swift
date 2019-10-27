//
//  MovieQueryObject.swift
//  MVVM
//
//  Created by Michal Ziobro on 26/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation
import RealmSwift

public class MoviesQueryRealmObject: Object {
    @objc dynamic var id = ""
    @objc dynamic var createdAt: Date = Date()
    @objc dynamic var query : String?
    @objc dynamic var page: Int64 = 0
    @objc dynamic var totalPages: Int64 = 0
    
    override public static func primaryKey() -> String? {
        return "id"
    }
    
    // Relationships
    let results = List<MovieRealmObject>()
    let images = List<PosterImageRealmObject>()
}

extension MoviesQueryRealmObject {
    
    func encode(entity e: MoviesQuery) {
        
        self.id = e._identifier
        self.page = Int64(e.page)
        self.totalPages = Int64(e.totalPages)
        self.query = e.query
       
//        let movies : [RealmModel.MovieObject] = e.results
//            .map { (m : Movie) in
//                let movie = RealmModel.MovieObject()
//                movie.encode(entity: m)
//                return movie
//            }
//
//        let list = List<RealmModel.MovieObject>()
//        list.append(objectsIn: movies)
        
        let ids = e.results.map { $0._identifier }
        let existing = self.results.map { $0.id }
        
        let toUpdate = e.results.filter {
            existing.contains($0._identifier)
        }.map { movie in
            (movie, self.results.firstIndex(where: { $0.id == movie._identifier })!)
        }
        
        let toInsert = e.results.filter {
            !existing.contains($0._identifier)
        }
        let toRemove = self.results.enumerated()
            .filter { ids.contains($0.element.id) == false }
            .map { $0.offset }
        
        toInsert.forEach { movie in
            let o = MovieRealmObject()
            o.encode(entity: movie)
            self.results.append(o)
        }
        
        toUpdate.forEach {
            let (m, idx) = $0
            let o = self.results[idx]
            o.encode(entity: m)
            self.results.insert(o, at: idx)
        }
        
        toRemove.forEach {
            self.results.remove(at: $0)
        }
    }
    
    func decode() -> MoviesQuery {
        
        let movies : [Movie] = self.results.map { $0.decode() }
        
        return MoviesQuery(query: self.query, page: Int(self.page), totalPages: Int(self.totalPages),
            results: movies)
    }
}
