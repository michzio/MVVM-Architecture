//
//  Movie.swift
//  MVVM
//
//  Created by Michal Ziobro on 19/09/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation

import RxDataSources

struct Movie {
        
    let id: Int
    let title: String
    let posterPath: String?
    let overview: String
    let releaseDate: String?
}


struct MoviesQuery {
    
    var query: String?
    
    let page: Int
    let totalPages: Int
    let results: [Movie]
    
}

extension Movie : Codable {
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case posterPath = "poster_path"
        case overview
        case releaseDate = "release_date"
    }
}

extension MoviesQuery : Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case page
        case totalPages = "total_pages"
        case results
    }
}

extension Movie : Identifiable {
    
    var _identifier: String {
        return "\(id)"
    }
}

extension Movie : IdentifiableType {
    
    var identity: Int {
        return id
    }
}

extension Movie : Hashable {
    
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension MoviesQuery : Identifiable {
    
    var _identifier: String {
        return "\(page)-\(query ?? "")"
    }
}

extension MoviesQuery : Hashable {
    
    static func == (lhs: MoviesQuery, rhs: MoviesQuery) -> Bool {
        return lhs.query == rhs.query && lhs.page == rhs.page
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(query)
        hasher.combine(page)
    }
}
