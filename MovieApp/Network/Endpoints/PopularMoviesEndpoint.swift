//
//  PopularMoviesEndpoint.swift
//  MovieApp
//
//  Created by esundaram esundaram on 09/02/23.
//

import Foundation

enum PopularMoviesEndpoint {
    case getPopularMovies(page: Int)
}

extension PopularMoviesEndpoint: Endpoint {
    var path: String {
        switch self {
        case .getPopularMovies:
            return "/movie/popular"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getPopularMovies:
            return .get
        }
    }

    var queryParams: [URLQueryItem] {
        switch self {
        case .getPopularMovies(let page):
            return [
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "api_key", value: "0e7274f05c36db12cbe71d9ab0393d47")
            ]
        }
    }
}

