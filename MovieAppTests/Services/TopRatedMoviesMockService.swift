//
//  TopRatedMoviesMockService.swift
//  MovieAppTests
//
//  Created by esundaram esundaram on 10/02/23.
//

import XCTest

@testable import MovieApp

final class TopRatedMoviesMockService: TopRatedMoviesServiceProtocol {
    var getTopRatedMoviesToBeReturned: (Result<MoviesResponse, ErrorHandler>)?
    private(set) var getTopRatedMoviesCalled = false
    private(set) var getTopRatedMoviesCallCount: Int = 0
    private(set) var getTopRatedMoviesPagePassed: Int?
    
    func getTopRatedMovies(page: Int, completion: @escaping (Result<MoviesResponse, ErrorHandler>) -> Void) {
        getTopRatedMoviesCalled = true
        getTopRatedMoviesCallCount += 1
        getTopRatedMoviesPagePassed = page
        
        guard let getTopRatedMoviesToBeReturned = getTopRatedMoviesToBeReturned else {
            return completion(.failure(ErrorHandler.noResponse))
        }
        
        return completion(getTopRatedMoviesToBeReturned)
    }
}
