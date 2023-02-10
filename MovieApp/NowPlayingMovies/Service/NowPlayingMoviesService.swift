//
//  NowPlayingMoviesService.swift
//  MovieApp
//
//  Created by esundaram esundaram on 08/02/23.
//

import Foundation

protocol NowPlayingMoviesServiceProtocol {
    func getNowPlayingMovies(page: Int, completion: @escaping (Result<MoviesResponse, ErrorHandler>) -> Void)
}

final class NowPlayingMoviesService: NowPlayingMoviesServiceProtocol {
    private let httpClient: HTTPClientProtocol
    
    init(httpClient: HTTPClientProtocol = HTTPClient.shared) {
        self.httpClient = httpClient
    }
    
    func getNowPlayingMovies(page: Int, completion: @escaping (Result<MoviesResponse, ErrorHandler>) -> Void) {
        httpClient.request(
            endpoint: MoviesEndpoint.getNowPlayingMovies(page: page),
            model: MoviesResponse.self,
            completion: completion
        )
    }
}
