//
//  IPosterImageDao.swift
//  MVVM
//
//  Created by Michal Ziobro on 25/09/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation

protocol IPosterImagesDao {
    
    func load(imagePath: String, width: Int, completion: @escaping (Result<PosterImage, Error>) -> Void)
    
    // IDao
    func insert(_ e: PosterImage, completion: @escaping (Result<PosterImage, Error>) -> Void)
    func insertReplacing(_ e: PosterImage, completion: @escaping (Result<PosterImage, Error>) -> Void)
    func delete(_ e: PosterImage, completion: @escaping (Result<Int, Error>) -> Void)
    func update(_ e: PosterImage, completion: @escaping (Result<PosterImage, Error>) -> Void)
    func load(id: String, completion: @escaping (Result<PosterImage, Error>) -> Void)
    func loadAll(completion: @escaping (Result<[PosterImage], Error>) -> Void)
}
