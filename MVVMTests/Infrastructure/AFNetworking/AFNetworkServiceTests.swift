//
//  AFNetworkServiceTests.swift
//  MVVMTests
//
//  Created by Michal Ziobro on 21/09/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import XCTest
@testable import MVVM
import Alamofire

class AFNetworkServiceTests: XCTestCase {
    
    private var sut: AFNetworkService!

    override func setUp() {
        super.setUp()
        
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.protocolClasses = [URLProtocolMock.self]
        let session = Session(configuration: sessionConfig)
        
        let config = NetworkConfigurationMock()
        
        sut = AFNetworkService(config: config, session: session)
    }

    override func tearDown() {
        super.tearDown()
        
        sut = nil
    }
    
    /*
    func test_whenMockDataPassed_shouldReturnProperResponse() {
        
        // given
        let data = "Response data".data(using: .utf8)!
        URLProtocolMock.responseWithData(code: 200, data: data)
        
        let expectation = XCTestExpectation(description: "should get valid data")
        
        // when
        _ = sut.request(with: Router.sample) { result in
            guard let responseData = try? result.get() else {
                XCTFail("Should get valid data.")
                return
            }
            XCTAssertEqual(responseData, data)
            expectation.fulfill()
        }
        
        // then
        wait(for: [expectation], timeout: 0.1)
    }*/
    
}
