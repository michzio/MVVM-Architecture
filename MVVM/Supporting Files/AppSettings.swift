//
//  AppSettings.swift
//  MVVM
//
//  Created by Michal Ziobro on 21/09/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation

struct AppSettings {
    
    static let shared = AppSettings()
    
    private init() {}
    
    lazy var apiKey: String = {
        
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "ApiKey") as? String else {
            fatalError("ApiKey must be defined in plist")
        }
        
        return apiKey
    }()
    
    lazy var apiBaseURL: String = {
        
        guard let url = Bundle.main.object(forInfoDictionaryKey: "ApiBaseURL") as? String else {
            fatalError("ApiBaseURL mut be defined in plist")
        }
        
        return url
    }()
    
    lazy var imagesBaseURL: String = {
       
        guard let url = Bundle.main.object(forInfoDictionaryKey: "ImagesBaseURL") as? String else {
            fatalError("ImagesBaseURL must be defined in plist")
        }
        
        return url
    }()
}
