//
//  PopularMoviesService.swift
//  MovieApp
//
//  Created by esundaram esundaram on 09/02/23.
//

import Foundation

protocol PopularMoviesServiceProtocol {
    func getPopularMovies(page: Int, completion: @escaping (Result<MoviesResponse, ErrorHandler>) -> Void)
}

final class PopularMoviesService: PopularMoviesServiceProtocol {
    private let httpClient: HTTPClientProtocol
    
    init(httpClient: HTTPClientProtocol = HTTPClient.shared) {
        self.httpClient = httpClient
    }
    
    func getPopularMovies(page: Int, completion: @escaping (Result<MoviesResponse, ErrorHandler>) -> Void) {
        httpClient.request(
            endpoint: MoviesEndpoint.getPopularMovies(page: page),
            model: MoviesResponse.self,
            completion: completion
        )
    }
}
