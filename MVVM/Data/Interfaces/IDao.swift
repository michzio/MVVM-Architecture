//
//  IDao.swift
//  MVVM
//
//  Created by Michal Ziobro on 21/09/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation

enum DaoError : Error {
    case insertionConflict
    case notFound
}

protocol IDao {
    associatedtype Entity
    
    func insert(e: Entity, completion: @escaping (Result<Entity, Error>) -> Void)
    func insertReplacing(e: Entity, completion: @escaping (Result<Entity, Error>) -> Void)
    func delete(e: Entity, completion: @escaping (Result<Int, Error>) -> Void)
    func update(e: Entity, completion: @escaping (Result<Entity, Error>) -> Void)
    func load(id: String, completion: @escaping (Result<Entity, Error>) -> Void)
    func loadAll(completion: @escaping (Result<[Entity], Error>) -> Void)
}
