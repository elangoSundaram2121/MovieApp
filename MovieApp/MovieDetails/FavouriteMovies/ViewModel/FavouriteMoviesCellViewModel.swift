//
//  favouriteMoviesCellViewModel.swift
//  MovieApp
//
//  Created by esundaram esundaram on 09/02/23.
//

import Foundation

struct FavouriteMoviesCellViewModel {
    
    // MARK: Properties
    
    private let movie: FavouriteMovieDetails
    
    // MARK: Initialization
    
    init(movie: FavouriteMovieDetails) {
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
        guard  let movieTitle = movie.title else {
            return ""
        }
        return movieTitle
    }
    
    var rating: String {
        return String(movie.voteAverage)
    }
}
