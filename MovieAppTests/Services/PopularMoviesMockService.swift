//
//  PopularMoviesMockService.swift
//  MovieAppTests
//
//  Created by esundaram esundaram on 10/02/23.
//

import XCTest

@testable import MovieApp

final class PopularMoviesMockService: PopularMoviesServiceProtocol {
    var getPopularMoviesToBeReturned: (Result<MoviesResponse, ErrorHandler>)?
    private(set) var getPopularMoviesCalled = false
    private(set) var getPopularMoviesCallCount: Int = 0
    private(set) var getPopularMoviesPagePassed: Int?
    
    func getPopularMovies(page: Int, completion: @escaping (Result<MoviesResponse, ErrorHandler>) -> Void) {
        getPopularMoviesCalled = true
        getPopularMoviesCallCount += 1
        getPopularMoviesPagePassed = page
        
        guard let getPopularMoviesToBeReturned = getPopularMoviesToBeReturned else {
            return completion(.failure(ErrorHandler.noResponse))
        }
        
        return completion(getPopularMoviesToBeReturned)
    }
}
