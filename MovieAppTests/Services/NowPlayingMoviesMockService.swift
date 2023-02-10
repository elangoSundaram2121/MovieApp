//
//  NowPlayingMoviesMockService.swift
//  MovieAppTests
//
//  Created by esundaram esundaram on 10/02/23.
//

import XCTest

@testable import MovieApp

final class NowPlayingMoviesMockService: NowPlayingMoviesServiceProtocol {
    
    var getNowPlayingMoviesToBeReturned: (Result<MoviesResponse, ErrorHandler>)?
    private(set) var getNowPlayingMoviesCalled = false
    private(set) var getNowPlayingMoviesCallCount: Int = 0
    private(set) var getNowPlayingMoviesPagePassed: Int?
    
    func getNowPlayingMovies(page: Int, completion: @escaping (Result<MovieApp.MoviesResponse, MovieApp.ErrorHandler>) -> Void) {
        getNowPlayingMoviesCalled = true
        getNowPlayingMoviesCallCount += 1
        getNowPlayingMoviesPagePassed = page
        
        guard let getNowPlayingMoviesToBeReturned = getNowPlayingMoviesToBeReturned else {
            return completion(.failure(ErrorHandler.noResponse))
        }
        
        return completion(getNowPlayingMoviesToBeReturned)
    }
    
}
