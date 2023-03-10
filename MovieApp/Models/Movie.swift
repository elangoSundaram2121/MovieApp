//
//  Movie.swift
//  MovieApp
//
//  Created by esundaram esundaram on 08/02/23.
//

import Foundation

struct Movie: Decodable, Hashable {

    let uuid = UUID()

    let id: Int
    let title: String
    let genres: [MovieGenre]?
    let genreIds: [Int]?
    let overview: String
    let releaseDate: String?
    let runtime: Int?
    let voteAverage: Double
    let backdropPath: String?
    let posterPath: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case genres
        case genreIds = "genre_ids"
        case overview
        case releaseDate = "release_date"
        case runtime
        case voteAverage = "vote_average"
        case backdropPath = "backdrop_path"
        case posterPath = "poster_path"
    }
}

extension Movie: Equatable {



    static func ==(lhs: Movie, rhs: Movie) -> Bool {
        return lhs.uuid == rhs.uuid
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }

}
