//
//  Movie.swift
//  MVVM
//
//  Created by Michal Ziobro on 19/09/2019.
//  Copyright © 2019 Michal Ziobro. All rights reserved.
//

import Foundation

struct Movie {
        
    let id: Int
    let title: String
    let posterPath: String?
    let overview: String
    let releaseDate: String?
}


struct MoviesPage {
        
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

extension MoviesPage : Decodable {
    
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

extension Movie : Hashable {
    
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
