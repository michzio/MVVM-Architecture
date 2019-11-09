//
//  IPosterImagesRepository.swift
//  MVVM
//
//  Created by Michal Ziobro on 25/09/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation
import RxSwift

protocol IPosterImagesRepository {
    
    func image(with imagePath: String, width: Int) -> Observable<PosterImage?>
}
