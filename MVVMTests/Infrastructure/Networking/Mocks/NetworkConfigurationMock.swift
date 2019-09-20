//
//  NetworkConfigurationMock.swift
//  MVVMTests
//
//  Created by Michal Ziobro on 20/09/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation
@testable import MVVM

class NetworkConfigurationMock: INetworkConfiguration {
    var baseURL: URL = URL(string: "https://mock.com")!
    var headers: [String: String] = [:]
    var queryParams : [String: String] = [:]
}
