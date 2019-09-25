//
//  IMoviesQueryDao.swift
//  MVVM
//
//  Created by Michal Ziobro on 22/09/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation

protocol IMoviesQueryDao {
    
    func load(query: String, page: Int, completion: @escaping (Result<MoviesQuery, Error>) -> Void)
    func recent(number: Int, completion: @escaping (Result<[MoviesQuery], Error>) -> Void)
    func sync(moviesQuery: MoviesQuery, completion: @escaping (Result<MoviesQuery, Error>) -> Void)
    
    // IDao
    func insert(_ e: MoviesQuery, completion: @escaping (Result<MoviesQuery, Error>) -> Void)
    func insertReplacing(_ e: MoviesQuery, completion: @escaping (Result<MoviesQuery, Error>) -> Void)
    func delete(_ e: MoviesQuery, completion: @escaping (Result<Int, Error>) -> Void)
    func update(_ e: MoviesQuery, completion: @escaping (Result<MoviesQuery, Error>) -> Void)
    func load(id: String, completion: @escaping (Result<MoviesQuery, Error>) -> Void)
    func loadAll(completion: @escaping (Result<[MoviesQuery], Error>) -> Void)
}
