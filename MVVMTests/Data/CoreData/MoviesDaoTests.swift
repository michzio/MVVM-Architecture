//
//  MoviesDaoTests.swift
//  MVVMTests
//
//  Created by Michal Ziobro on 22/09/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import XCTest

import RxSwift
import RxBlocking

@testable import MVVM

class MoviesDaoTests: XCTestCase {
    
    var storage : ICoreDataStorage!
    
    override func setUp() {
        storage = InMemoryCoreDataStorage()
    }
    
    override func tearDown() {
        storage = nil
    }
    
    func test_whenMovieSaved_shouldBeRetrievable() {
        
        // given
        let dao = MoviesDao(storage: storage)
        let movie = Movie(id: 1, title: "Test Title", posterPath: nil, overview: "Test Details", releaseDate: nil)
        
        let insertExpectation = self.expectation(description: "Should insert entity.")
        let loadExpectation = self.expectation(description: "Should load entity.")
        let changeExpectation = self.expectation(forNotification: .NSManagedObjectContextDidSave, object: storage.persistentContainer.viewContext, handler: nil)
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
        wait(for: [changeExpectation], timeout: 2)
    }
    
    func test_whenDuplicateInsertion_shouldThrowConflict() {
        
        // given
        let dao = MoviesDao(storage: storage)
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
        let dao = MoviesDao(storage: storage)
        let movie1 = Movie(id: 1, title: "Test Title", posterPath: nil, overview: "Test Details", releaseDate: nil)
        let movie2 = Movie(id: 1, title: "Test Other Title", posterPath: nil, overview: "Test Overview", releaseDate: nil)
               
        let expectation = self.expectation(description: "On replacing insert, object should be replaced.")
        let changeExpectation = self.expectation(forNotification: .NSManagedObjectContextObjectsDidChange, object: storage.persistentContainer.viewContext, handler: nil)
               
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
        wait(for: [changeExpectation], timeout: 2.0)
    }
    
    func test_whenDelete_shouldRemoveObject() {
        
        // given
        let dao = MoviesDao(storage: storage)
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
    
    func test_whenSyncMovies_shouldLoadThem() {
        
        // given
        let dao = MoviesDao(storage: storage)
        
        let movie1 = Movie(id: 1, title: "Test Title 1", posterPath: nil, overview: "Test Details 1", releaseDate: nil)
        let movie2 = Movie(id: 2, title: "Test Title 2", posterPath: nil, overview: "Test Details 2", releaseDate: nil)
        let movie3 = Movie(id: 3, title: "Test Title 3", posterPath: nil, overview: "Test Details 3", releaseDate: nil)
        
        
        let movie2B = Movie(id: 2, title: "Test B Title 2", posterPath: nil, overview: "Test B Details 2", releaseDate: nil)
        let movie3B = Movie(id: 3, title: "Test B Title 3", posterPath: nil, overview: "Test B Details 3", releaseDate: nil)
        let movie4B = Movie(id: 4, title: "Test Title 4", posterPath: nil, overview: "Test B Details 4", releaseDate: nil)
        
        let expectation = self.expectation(description: "Should load synced movies")
        
        // when
        dao.sync(movies: [movie1, movie2, movie3]) { result in
            let success = (try? result.get()) ?? false
            XCTAssert(success, "Should sync first movies collection")
            
            dao.sync(movies: [movie2B, movie3B, movie4B]) { result in
                let success = (try? result.get()) ?? false
                XCTAssert(success, "Should sync second movies collection")
                
                dao.load(query: "Test B") { result in
                    
                    let movies = (try? result.get())
                    XCTAssertNotNil(movies, "Should load test B movies")
                    XCTAssertEqual(movies!.count, 3)
                    XCTAssertEqual(movies!.sorted(by: \.id).first!.title, movie2B.title)
                    XCTAssertEqual(movies!.sorted(by: \.id).last!.title, movie4B.title)
                    
                    dao.load(query: "Test Title") { result in
                        
                        let movies = (try? result.get())
                        XCTAssertNotNil(movies, "Should load test A movies")
                        XCTAssertEqual(movies!.count, 2)
                        XCTAssertEqual(movies!.sorted(by: \.id).first!.title, movie1.title)
                        XCTAssertEqual(movies!.sorted(by: \.id).last!.title, movie4B.title)
                        expectation.fulfill()
                    }
                }
            }
        }
        
        // then
        wait(for: [expectation], timeout: 0.5)
    }
}

// MARK: - Rx
extension MoviesDaoTests {
    
    func test_rx_whenMovieSaved_shouldBeRetrievable() {
        
        // given
        let dao = MoviesDao(storage: storage)
        let movie = Movie(id: 1, title: "Test Title", posterPath: nil, overview: "Test Details", releaseDate: nil)
        
        // when
        let inserted = try? dao.insert(movie).toBlocking(timeout: 0.1).first()
        let result = try? dao.load(id: "\(movie.id)").toBlocking(timeout: 0.1).first()
        
        // then
        XCTAssertNotNil(inserted, "Should insert movie")
        XCTAssertNotNil(result, "Should load movie")
        XCTAssertEqual(inserted, movie)
        XCTAssertEqual(result, movie)
    }
    
    func test_rx_whenDuplicateInsertion_shouldThrowConflict() {
        
        // given
        let dao = MoviesDao(storage: storage)
        let movie = Movie(id: 1, title: "Test Title", posterPath: nil, overview: "Test Details", releaseDate: nil)
        
        // when
        let e = try? dao.insert(movie).toBlocking(timeout: 0.1).first()
        let result = dao.insert(movie).toBlocking(timeout: 0.1).materialize()
        
        // hen
        XCTAssertNotNil(e, "Should insert movie")
        XCTAssertEqual(e, movie)
        
        switch result {
        case .completed:
            XCTFail("Should throw error insertion conflict.")
        case .failed(_, let error):
            guard case DaoError.insertionConflict = error else {
                XCTFail("Should throw insertion conflict.")
                return
            }
        }
    }
    
    func test_rx_whenInsertReplacing_shouldReplaceObject() {
        
        // given
        let dao = MoviesDao(storage: storage)
        let movie1 = Movie(id: 1, title: "Test Title", posterPath: nil, overview: "Test Details", releaseDate: nil)
        let movie2 = Movie(id: 1, title: "Test Other Title", posterPath: nil, overview: "Test Overview", releaseDate: nil)
        
        let changeExpectation = self.expectation(forNotification: .NSManagedObjectContextObjectsDidChange, object: storage.persistentContainer.viewContext, handler: nil)
        
        // when
        let e1 = try? dao.insert(movie1).toBlocking(timeout: 0.1).first()
        let e2 = try? dao.insertReplacing(movie2).toBlocking(timeout: 0.1).first()
        
        // then
        XCTAssertNotNil(e1, "Should insert movie1")
        XCTAssertNotNil(e2, "Should insert replacing movie2")
        XCTAssertEqual(e1, movie1)
        XCTAssertEqual(e2, movie2)
        
        wait(for: [changeExpectation], timeout: 2.0)
    }
    
    func test_rx_whenDelete_shouldRemoveObject() {
        
        // given
        let dao = MoviesDao(storage: storage)
        let movie = Movie(id: 1, title: "Test Title", posterPath: nil, overview: "Test Details", releaseDate: nil)
        
        // when
        let e1 = try? dao.insert(movie).toBlocking(timeout: 0.1).first()
        let count = try? dao.delete(movie).toBlocking(timeout: 0.1).first()
        
        // then
        XCTAssertNotNil(e1, "Should insert movie")
        XCTAssertEqual(e1, movie)
        XCTAssertEqual(count, 1, "Should delete 1 movie")
    }
    
    func test_rx_whenSyncMovies_shouldLoadThem() {
        
        // given
        let dao = MoviesDao(storage: storage)
        
        let movie1 = Movie(id: 1, title: "Test Title 1", posterPath: nil, overview: "Test Details 1", releaseDate: nil)
        let movie2 = Movie(id: 2, title: "Test Title 2", posterPath: nil, overview: "Test Details 2", releaseDate: nil)
        let movie3 = Movie(id: 3, title: "Test Title 3", posterPath: nil, overview: "Test Details 3", releaseDate: nil)
        
        let movie2B = Movie(id: 2, title: "Test B Title 2", posterPath: nil, overview: "Test B Details 2", releaseDate: nil)
        let movie3B = Movie(id: 3, title: "Test B Title 3", posterPath: nil, overview: "Test B Details 3", releaseDate: nil)
        let movie4B = Movie(id: 4, title: "Test Title 4", posterPath: nil, overview: "Test B Details 4", releaseDate: nil)
        
        // when
        let result1 = try? dao.sync(movies: [movie1, movie2, movie3]).toBlocking(timeout: 0.5).first()
        let result2 = try? dao.sync(movies: [movie2B, movie3B, movie4B]).toBlocking(timeout: 0.5).first()
        
        let movies1 = try? dao.load(query: "Test B").toBlocking(timeout: 0.1).first()
        let movies2 = try? dao.load(query: "Test Title").toBlocking(timeout: 0.1).first()
        
        // then
        XCTAssert(result1 == true, "Should sync first movies collection")
        XCTAssert(result2 == true, "Should sync second movies collection")
        
        XCTAssertNotNil(movies1, "Should load test B movies")
        XCTAssertEqual(movies1!.count, 3)
        XCTAssertEqual(movies1!.sorted(by: \.id).first!.title, movie2B.title)
        XCTAssertEqual(movies1!.sorted(by: \.id).last!.title, movie4B.title)
        
        XCTAssertNotNil(movies2, "Should load test A movies")
        XCTAssertEqual(movies2!.count, 2)
        XCTAssertEqual(movies2!.sorted(by: \.id).first!.title, movie1.title)
        XCTAssertEqual(movies2!.sorted(by: \.id).last!.title, movie4B.title)
    }
}
