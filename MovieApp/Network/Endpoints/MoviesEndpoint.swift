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
    case searchMovie(query: String, page: Int)
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
        case .searchMovie:
            return "/search/movie"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getTopRatedMovies, .getUpcomingMovies, .getPopularMovies, .getNowPlayingMovies, .getMovie, .searchMovie:
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
        case .searchMovie(let query, let page):
            return [
                URLQueryItem(name: "query", value: query),
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "api_key", value: "0e7274f05c36db12cbe71d9ab0393d47")
            ]
        }
    }
}
