//
//  Observable.swift
//  MVVM
//
//  Created by Michal Ziobro on 21/09/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation

// Alternative, custom solution
// to RxSwift or Combine frameworks

public final class LiveData<Value> {
        
        struct Observer<Value> {
            weak var observer: AnyObject?
            let closure: (Value) -> Void
        }
        
        private var observers = [Observer<Value>]()
        
        public var value: Value {
            didSet { notifyObservers() }
        }
        
        public init(_ value: Value) {
            self.value = value
        }
        
        public func observe(on observer: AnyObject, closure: @escaping (Value) -> Void) {
            observers.append(Observer(observer: observer, closure: closure))
            DispatchQueue.main.async {
                closure(self.value)
            }
        }
        
        public func remove(observer: AnyObject) {
            observers = observers.filter { $0.observer !== observer }
        }
        
        private func notifyObservers() {
            observers.forEach { observer in
                DispatchQueue.main.async {
                    observer.closure(self.value)
                }
            }
        }
}
