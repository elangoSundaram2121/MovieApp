//
//  TopRatedMoviesService.swift
//  MovieApp
//
//  Created by esundaram esundaram on 09/02/23.
//

import Foundation

protocol TopRatedMoviesServiceProtocol {
    func getTopRatedMovies(page: Int, completion: @escaping (Result<MoviesResponse, ErrorHandler>) -> Void)
}

final class TopRatedMoviesService: TopRatedMoviesServiceProtocol {
    private let httpClient: HTTPClientProtocol
    
    init(httpClient: HTTPClientProtocol = HTTPClient.shared) {
        self.httpClient = httpClient
    }
    
    func getTopRatedMovies(page: Int, completion: @escaping (Result<MoviesResponse, ErrorHandler>) -> Void) {
        httpClient.request(
            endpoint: MoviesEndpoint.getTopRatedMovies(page: page),
            model: MoviesResponse.self,
            completion: completion
        )
    }
}
