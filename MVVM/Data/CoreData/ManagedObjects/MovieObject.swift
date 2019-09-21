//
//  MovieObject.swift
//  MVVM
//
//  Created by Michal Ziobro on 21/09/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import UIKit
import CoreData

class MovieObject: NSManagedObject {

    @NSManaged var id: String
    @NSManaged var title: String
    @NSManaged var posterPath: String?
    @NSManaged var overview: String
    @NSManaged var releaseDate: String?
}
