//
//  IMovieItemViewModel.swift
//  MVVM
//
//  Created by Michal Ziobro on 03/11/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation
import RxSwift

protocol IMovieItemViewModel {
    
    // MARK: - Outputs
    var posterImage: Observable<Data?> { get }
    
    // MARK: - Inputs
    func updatePosterImage(path: String, width: Int) 
}
