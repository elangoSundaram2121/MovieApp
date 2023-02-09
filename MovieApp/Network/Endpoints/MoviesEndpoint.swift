//
//  TopRatedMoviesEndpoint.swift
//  MovieApp
//
//  Created by esundaram esundaram on 09/02/23.
//

import Foundation

enum MoviesEndpoint {
    case getTopRatedMovies(page: Int)
    case getPopularMovies(page: Int)
    case getNowPlayingMovies(page: Int)
    case getUpcomingMovies(page: Int)
    case getMovie(id: Int)
}

extension MoviesEndpoint: Endpoint {
    var path: String {
        switch self {
        case .getTopRatedMovies:
            return "/movie/top_rated"
        case .getNowPlayingMovies:
            return "/movie/now_playing"
        case .getPopularMovies:
            return "/movie/popular"
        case .getUpcomingMovies:
            return "/movie/upcoming"
        case .getMovie(let id):
            return "/movie/\(id)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getTopRatedMovies, .getUpcomingMovies, .getPopularMovies, .getNowPlayingMovies, .getMovie:
            return .get
        }
    }

    var queryParams: [URLQueryItem] {
        switch self {
        case .getTopRatedMovies(let page), .getNowPlayingMovies(let page), .getUpcomingMovies(let page), .getPopularMovies(let page):
            return [
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "api_key", value: "0e7274f05c36db12cbe71d9ab0393d47")
            ]
        case .getMovie:
            return [
                URLQueryItem(name: "api_key", value: "0e7274f05c36db12cbe71d9ab0393d47")
            ]
        }
    }
}
