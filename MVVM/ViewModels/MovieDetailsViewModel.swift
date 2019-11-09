//
//  MovieDetailsViewModel.swift
//  MVVM
//
//  Created by Michal Ziobro on 31/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation

class MovieDetailsViewModel : IMovieDetailsViewModel {
    
    
    func setMovie(_ movie: Movie) {
        
        print("Movie is: \(movie)")
    }
}
