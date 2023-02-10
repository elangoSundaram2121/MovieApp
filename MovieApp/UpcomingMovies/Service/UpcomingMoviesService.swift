//
//  UpcomingMoviesService.swift
//  MovieApp
//
//  Created by esundaram esundaram on 09/02/23.
//

import Foundation

protocol UpcomingMoviesServiceProtocol {
    func getUpcomingMovies(page: Int, completion: @escaping (Result<MoviesResponse, ErrorHandler>) -> Void)
}

final class UpcomingMoviesService: UpcomingMoviesServiceProtocol {
    private let httpClient: HTTPClientProtocol

    init(httpClient: HTTPClientProtocol = HTTPClient.shared) {
        self.httpClient = httpClient
    }

    func getUpcomingMovies(page: Int, completion: @escaping (Result<MoviesResponse, ErrorHandler>) -> Void) {
        httpClient.request(
            endpoint: MoviesEndpoint.getUpcomingMovies(page: page),
            model: MoviesResponse.self,
            completion: completion
        )
    }
}
