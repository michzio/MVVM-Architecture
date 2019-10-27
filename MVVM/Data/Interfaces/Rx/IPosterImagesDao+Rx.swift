//
//  File.swift
//  MVVM
//
//  Created by Michal Ziobro on 27/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation
import RxSwift

protocol IPosterImagesDao_Rx {
    
    func load(imagePath: String, width: Int) -> Observable<PosterImage>
    
    // IDao_Rx
    func insert(_ e: PosterImage) -> Observable<PosterImage>
    func insertReplacing(_ e: PosterImage) -> Observable<PosterImage>
    func delete(_ e: PosterImage) -> Observable<Int>
    func update(_ e: PosterImage) -> Observable<PosterImage>
    func load(id: String) -> Observable<PosterImage>
    func loadAll() -> Observable<[PosterImage]>
}

