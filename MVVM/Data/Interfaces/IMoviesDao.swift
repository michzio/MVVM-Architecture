//
//  IMoviesDao.swift
//  MVVM
//
//  Created by Michal Ziobro on 19/09/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation

protocol IMoviesDao {
    
    func load(query: String, completion: @escaping (Result<[Movie], Error>) -> Void)
    func sync(movies: [Movie], completion: @escaping (Result<Bool, Error>) -> Void)
    
    // IDao
    func insert(_ e: Movie, completion: @escaping (Result<Movie, Error>) -> Void)
    func insertReplacing(_ e: Movie, completion: @escaping (Result<Movie, Error>) -> Void)
    func delete(_ e: Movie, completion: @escaping (Result<Int, Error>) -> Void)
    func update(_ e: Movie, completion: @escaping (Result<Movie, Error>) -> Void)
    func load(id: String, completion: @escaping (Result<Movie, Error>) -> Void)
    func loadAll(completion: @escaping (Result<[Movie], Error>) -> Void)
}
