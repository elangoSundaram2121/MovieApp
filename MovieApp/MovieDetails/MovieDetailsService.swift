//
//  MovieDetailsService.swift
//  MovieApp
//
//  Created by esundaram esundaram on 09/02/23.
//

import Foundation

protocol MovieDetailsServiceProtocol {
    func getMovie(id: Int, completion: @escaping (Result<Movie, ErrorHandler>) -> Void)
}

class MovieDetailsService: MovieDetailsServiceProtocol {
    private let httpClient: HTTPClientProtocol
    
    init(httpClient: HTTPClientProtocol = HTTPClient.shared) {
        self.httpClient = httpClient
    }
    
    func getMovie(id: Int, completion: @escaping (Result<Movie, ErrorHandler>) -> Void) {
        httpClient.request(
            endpoint: MoviesEndpoint.getMovie(id: id),
            model: Movie.self,
            completion: completion
        )
    }
}
