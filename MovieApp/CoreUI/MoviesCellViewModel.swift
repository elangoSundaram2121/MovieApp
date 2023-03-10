//
//  MoviesCellViewModel.swift
//  MovieApp
//
//  Created by esundaram esundaram on 09/02/23.
//

import Foundation

struct MoviesCellViewModel {
    
    // MARK: Properties
    
    private let movie: Movie
    
    // MARK: Initialization
    
    init(movie: Movie) {
        self.movie = movie
    }
    
    // MARK: Presentation Properties
    
    var posterImageURL: String {
        guard let posterPath = movie.posterPath else {
            return "https://critics.io/img/movies/poster-placeholder.png"
        }
        return "https://image.tmdb.org/t/p/original" + posterPath
    }
    
    var title: String {
        return movie.title
    }
    
    var subtitle: String {
        guard let genreIds = movie.genreIds else {
            return "N/A"
        }
        
        let genreNames = genreIds.compactMap {
            MovieGenres(rawValue: $0)?.description
        }
        
        return genreNames.joined(separator: ", ")
    }
    
    var rating: String {
        return String(movie.voteAverage)
    }
}
