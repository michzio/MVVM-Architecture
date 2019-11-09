//
//  IPosterImagesService+Rx.swift
//  MVVM
//
//  Created by Michal Ziobro on 30/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation
import RxSwift

protocol IPosterImagesService_Rx {
    
    func getPosterImage(path: String, width: Int) -> Observable<PosterImage> 
}
