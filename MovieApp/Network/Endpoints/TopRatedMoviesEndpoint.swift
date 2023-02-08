//
//  TopRatedMoviesEndpoint.swift
//  MovieApp
//
//  Created by esundaram esundaram on 09/02/23.
//

import Foundation

enum TopRatedMoviesEndpoint {
    case getTopRatedMovies(page: Int)
}

extension TopRatedMoviesEndpoint: Endpoint {
    var path: String {
        switch self {
        case .getTopRatedMovies:
            return "/movie/top_rated"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getTopRatedMovies:
            return .get
        }
    }

    var queryParams: [URLQueryItem] {
        switch self {
        case .getTopRatedMovies(let page):
            return [
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "api_key", value: "0e7274f05c36db12cbe71d9ab0393d47")
            ]
        }
    }
}
