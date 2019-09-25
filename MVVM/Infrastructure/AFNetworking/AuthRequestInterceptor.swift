//
//  File.swift
//  MVVM
//
//  Created by Michal Ziobro on 17/09/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation
import Alamofire

class AuthRequestInterceptor : RequestInterceptor {
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        
        print("Request Adapter: \(urlRequest)")
        
        let urlRequest = urlRequest
        //urlRequest.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        
        completion(.success(urlRequest))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        
        print("Request Retrier: \(request) and \(error)")
        
        let error = error as NSError
        if error.code == NSURLErrorNetworkConnectionLost {
            print("RETRING LOST NETWORK CONNECTION")
            // should retry?
            if request.retryCount > 1 {
                completion(.doNotRetry)
            } else {
                completion(.retryWithDelay(1.0))
            }
        } else if error.code == NSURLErrorTimedOut {
            print("REQUEST TIMEOUT")
            completion(.doNotRetry)
        } else if let response = request.task?.response as? HTTPURLResponse {
            shouldRetryIfStatusCode(response.statusCode, request: request, completion: completion)
            return
        }
        
        completion(.doNotRetry)
    }
    
    private func shouldRetryIfStatusCode(_ statusCode : Int, request: Request, completion: @escaping (RetryResult) -> Void) {
    
        switch statusCode {
        case 401: // UNAUTHORIZED
            print("REQUEST RETRIER WITH STATUS CODE: 401")
            DispatchQueue.main.async {
                // TODO: COMMIT LOGOUT?
            }
        case 409: // CONFLICT
            print("REQUEST RETRIER WITH STATUS CODE: 409")
            completion(.doNotRetry)
        case 500: // INTERNAL SERVER ERROR
            print("Failed request: \(request)")
            print("REQUEST RETRIER WITH STATUS CODE: 500")
            completion(.doNotRetry)
        default:
            completion(.doNotRetry)
        }
        
    }
}
