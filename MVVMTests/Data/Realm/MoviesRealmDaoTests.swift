//
//  MoviesRealmDaoTests.swift
//  MVVMTests
//
//  Created by Michal Ziobro on 27/10/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import XCTest

import RxBlocking

@testable import MVVM

class MoviesRealmDaoTests: XCTestCase {
    
    var storage: InMemoryRealmStorage!
    
    override func setUp() {
        storage = InMemoryRealmStorage()
        storage.useCleanMemoryRealmByDefault()
    }
    
    override func tearDown() {
        storage = nil
    }
    
    func test_whenMovieSaved_shouldBeRetrivable() {
        
        // given
        let dao = MoviesRealmDao(storage: storage)
        let movie = Movie(id: 1, title: "Test Title", posterPath: nil, overview: "Test Details", releaseDate: nil)
        
        let insertExpectation = self.expectation(description: "Should insert entity.")
        let loadExpectation = self.expectation(description: "Should load entity.")
        
        // when
        dao.insert(movie) { (result) in
            
            guard let e = try? result.get() else {
                XCTFail("Should get valid entity back.")
                return
            }
            
            XCTAssertEqual(movie, e)
            insertExpectation.fulfill()
            
            dao.load(id: "\(movie.id)") { result in
                
                guard let e = try? result.get() else {
                    XCTFail("Should load valid entity back.")
                    return
                }
                
                XCTAssertEqual(movie, e)
                loadExpectation.fulfill()
            }
        }
        
        // then
        wait(for: [insertExpectation, loadExpectation], timeout: 0.2)
        
    }
    
    func test_whenDuplicateInsertion_shouldThrowConflict() {
        
        // given
        let dao = MoviesRealmDao(storage: storage)
        let movie = Movie(id: 1, title: "Test Title", posterPath: nil, overview: "Test Details", releaseDate: nil)
        
        let expectation = self.expectation(description: "On duplicate should throw insertion error.")
        
        // when
        dao.insert(movie) { result in
            dao.insert(movie) { result in
                
                do {
                    _ = try result.get()
                    XCTFail("Should throw error insertion conflict.")
                } catch {
                    guard case DaoError.insertionConflict = error else {
                        XCTFail("Should throw insertion conflict.")
                        return
                    }
                    expectation.fulfill()
                }
            }
        }
        
        // then
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_whenInsertReplacing_shouldReplaceObject() {
        
        // given
        let dao = MoviesRealmDao(storage: storage)
        let movie1 = Movie(id: 1, title: "Test Title", posterPath: nil, overview: "Test Details", releaseDate: nil)
        let movie2 = Movie(id: 1, title: "Test Other Title", posterPath: nil, overview: "Test Overview", releaseDate: nil)
        
        let expectation = self.expectation(description: "On replacing insert, object should be replaced.")
        
        // when
        dao.insert(movie1) { result in
            dao.insertReplacing(movie2) { result in
                do {
                    let object = try result.get()
                    XCTAssertEqual(object, movie2)
                    expectation.fulfill()
                } catch {
                    XCTFail("Should not throw any error")
                }
            }
        }
        
        // then
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_whenDeleting_shouldRemoveObject() {
        
        // given
        let dao = MoviesRealmDao(storage: storage)
        let movie = Movie(id: 1, title: "Test Title", posterPath: nil, overview: "Test Details", releaseDate: nil)
        
        let expectation = self.expectation(description: "Should remove deleting object.")
        
        // when
        dao.insert(movie) { result in
            dao.delete(movie) { result in
                do {
                    let count = try result.get()
                    XCTAssertEqual(count, 1)
                    expectation.fulfill()
                } catch {
                    XCTFail("Should not throw any error")
                }
            }
        }
        
        // then
        wait(for: [expectation], timeout: 0.1)
    }
}

// MARK: - Rx
extension MoviesRealmDaoTests {
    
    func test_rx_whenMovieSaved_shouldBeRetrivable() {
        
        // given
        let dao = MoviesRealmDao(storage: storage)
        let movie = Movie(id: 1, title: "Test Title", posterPath: nil, overview: "Test Details", releaseDate: nil)
        
        let e = try? dao.insert(movie).toBlocking(timeout: 1).first()
        
        XCTAssertNotNil(e, "Should get valid entity back")
        XCTAssertEqual(movie, e)
        
        let result = try? dao.load(id: "\(movie.id)").take(1).toBlocking(timeout: 1).first()
        
        XCTAssertNotNil(result, "Should load valid entity back.")
        XCTAssertEqual(movie, result)
    }
    
    func test_rx_whenDuplicateInsertion_shouldThrowConflict() {
        
        // given
        let dao = MoviesRealmDao(storage: storage)
        let movie = Movie(id: 1, title: "Test Title", posterPath: nil, overview: "Test Details", releaseDate: nil)
        
        // when
        do {
            let e1 = try dao.insert(movie).toBlocking(timeout: 1).first()
            
            XCTAssertNotNil(e1)
            
            _ = try dao.insert(movie).toBlocking(timeout: 1).first()
            
            XCTFail("Should throw error insertion conflict.")
        } catch {
            guard case DaoError.insertionConflict = error else {
                XCTFail("Should throw insertion conflict.")
                return
            }
            
            XCTAssertNotNil(error)
        }
        
    }
    
    func test_rx_whenInsertReplacing_shouldReplaceObject() {
        
        // given
        let dao = MoviesRealmDao(storage: storage)
        let movie1 = Movie(id: 1, title: "Test Title", posterPath: nil, overview: "Test Details", releaseDate: nil)
        let movie2 = Movie(id: 1, title: "Test Other Title", posterPath: nil, overview: "Test Overview", releaseDate: nil)
        
        // when
        do {
            let e1 = try dao.insert(movie1).toBlocking(timeout: 1).first()
            let e2 = try dao.insertReplacing(movie2).toBlocking(timeout: 1).first()
            
            // then
            XCTAssertNotNil(e1)
            XCTAssertEqual(movie2, e2)
        } catch {
            XCTFail("Should not throw any error")
        }
    }
}
