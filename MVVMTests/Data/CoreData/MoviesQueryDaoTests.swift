//
//  MoviesQueryDaoTests.swift
//  MVVMTests
//
//  Created by Michal Ziobro on 22/09/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import XCTest
@testable import MVVM 

class MoviesQueryDaoTests: XCTestCase {
    
    var storage : ICoreDataStorage!

    override func setUp() {
        storage = InMemoryCoreDataStorage()
    }

    override func tearDown() {
        storage = nil
    }

    func test_whenInsertingMoviesQuery_shouldStoreMovies() {
        
        // given
        let dao = MoviesQueryDao(storage: storage)
        let movie1 = Movie(id: 1, title: "Test Title 1", posterPath: nil, overview: "Test Details 1", releaseDate: nil)
        let movie2 = Movie(id: 2, title: "Test Title 2", posterPath: nil, overview: "Test Details 2", releaseDate: nil)
        let movie3 = Movie(id: 3, title: "Test Title 3", posterPath: nil, overview: "Test Details 3", releaseDate: nil)
        
        let movies = [movie1, movie2, movie3]
        let moviesQuery = MoviesQuery(query: "Test", page: 1, totalPages: 10, results: movies)
        
        let expectation = self.expectation(description: "Should save query with all movies")
        
        // when
        dao.insert(moviesQuery) { result in
            dao.load(id: moviesQuery._identifier) { result in
                do {
                    let query = try result.get()
                    XCTAssertEqual(movies, query.results.sorted(by: \.id))
                    expectation.fulfill()
                } catch {
                    XCTFail("Should return correct movies query object")
                }
            }
        }
        
        // then
        wait(for: [expectation], timeout: 0.1)
    }

}
