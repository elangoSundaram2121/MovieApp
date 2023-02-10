//
//  SearchMoviesService.swift
//  MovieApp
//
//  Created by esundaram esundaram on 10/02/23.
//

import Foundation

protocol SearchMoviesServiceProtocol {
    func searchMovie(query: String, page: Int,completion: @escaping (Result<MoviesResponse, ErrorHandler>) -> Void)
}

final class SearchMoviesService: SearchMoviesServiceProtocol {
    private let httpClient: HTTPClientProtocol
    
    init(httpClient: HTTPClientProtocol = HTTPClient.shared) {
        self.httpClient = httpClient
    }
    
    func searchMovie(query: String, page: Int, completion: @escaping (Result<MoviesResponse, ErrorHandler>) -> Void) {
        httpClient.request(
            endpoint: MoviesEndpoint.searchMovie(query: query, page: page),
            model: MoviesResponse.self,
            completion: completion
        )
    }
}
