//
//  PosterImagesDaoTests.swift
//  MVVMTests
//
//  Created by Michal Ziobro on 28/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import XCTest

import RxBlocking

@testable import MVVM

class PosterImagesDaoTests: XCTestCase {
    
    var storage: ICoreDataStorage!
    
    override func setUp() {
        storage = InMemoryCoreDataStorage()
    }
    
    override func tearDown() {
        storage = nil
    }
    
    func test_whenInsertedPosterImages_shouldLoadIt() {
        
        // given
        let dao = PosterImagesDao(storage: storage)
        let poster1 = PosterImage(path: "test_path_1", width: 100, data: Data())
        let poster2 = PosterImage(path: "test_path_2", width: 200, data: Data())
        
        let expectation = self.expectation(description: "Should save posters")
        
        // when
        dao.insert(poster1) { result in
            dao.insert(poster2) { result in
                dao.load(imagePath: "test_path_1", width: 100) { result in
                    
                    do {
                        let poster = try result.get()
                        XCTAssertEqual(poster, poster1)
                        expectation.fulfill()
                    } catch {
                        XCTFail("Should load correct poster image object")
                    }
                }
            }
        }
        
        // then
        wait(for: [expectation], timeout: 0.1)
    }
}

// MARK: - Rx
extension PosterImagesDaoTests {
    
    func test_rx_whenInsertedPosterImages_shouldLoadIt() {
        
        // given
        let dao = PosterImagesDao(storage: storage)
        let poster1 = PosterImage(path: "test_path_1", width: 100, data: Data())
        let poster2 = PosterImage(path: "test_path_2", width: 200, data: Data())
        
        let e1 = try? dao.insert(poster1).toBlocking(timeout: 0.1).first()
        let e2 = try? dao.insert(poster2).toBlocking(timeout: 0.1).first()
        
        XCTAssertNotNil(e1, "Should insert poster1.")
        XCTAssertNotNil(e2, "Should insert poster2.")
        XCTAssertEqual(e1, poster1)
        XCTAssertEqual(e2, poster2)
        
        let res1 = try? dao.load(imagePath: "test_path_1", width: 100).take(1).toBlocking(timeout: 0.1).first()
        let res2 = try? dao.load(imagePath: "test_path_2", width: 200).take(2).toBlocking(timeout: 0.1).first()
        
        XCTAssertNotNil(res1, "Should load poster1.")
        XCTAssertNotNil(res2, "Should load poster2.")
        XCTAssertEqual(res1, poster1)
        XCTAssertEqual(res2, poster2)
    
    }
}
