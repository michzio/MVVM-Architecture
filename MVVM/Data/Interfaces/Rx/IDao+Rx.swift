//
//  IDao+Rx.swift
//  MVVM
//
//  Created by Michal Ziobro on 27/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation
import RxSwift 

protocol IDao_Rx {
    associatedtype Entity
    
    func insert(_ e: Entity) -> Observable<Entity>
    func insertReplacing(_ e: Entity) -> Observable<Entity>
    func delete(_ e: Entity) -> Observable<Int>
    func update(_ e: Entity) -> Observable<Entity>
    func load(id: String) -> Observable<Entity>
    func loadAll() -> Observable<[Entity]>
}
