//
//  PopularMoviesCellViewModel.swift
//  MovieApp
//
//  Created by esundaram esundaram on 09/02/23.
//

import Foundation

struct PopularMoviesCellViewModel {
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
}

