//
//  AFAuth.swift
//  MVVM
//
//  Created by Michal Ziobro on 17/09/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation
import Alamofire


class AFAuth {
    
    public static let session : Session = {
        let session = Session(interceptor: AuthRequestInterceptor())
        return session
    }()
    
    
    @discardableResult
    public static func request(_ urlRequest: URLRequestConvertible) -> DataRequest {
        return AFAuth.session.request(urlRequest)
    }
}
