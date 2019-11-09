//
//  PosterImageObject+Mapping.swift
//  MVVM
//
//  Created by Michal Ziobro on 25/09/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import CoreData

extension PosterImageObject {
    
    func encode(entity e: PosterImage) {
        self.id = e._identifier
        self.path = e.path
        self.data = e.data
        self.width = Int32(e.width)
        
        let request = MovieObject.fetchRequest()
        request.predicate = NSPredicate(format: "posterPath = %@", e.path)

        if let movie = (try? request.execute().first as? MovieObject) {
            self.movie = movie
        }
    }
    
    func decode() -> PosterImage {
    
        return PosterImage(path: self.path!, width: Int(self.width), data: self.data!)
    }
}
