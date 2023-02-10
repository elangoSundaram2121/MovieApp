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
        let apiKey = getAuthInfoFromPropertyList()

        switch self {
        case .getTopRatedMovies(let page), .getNowPlayingMovies(let page), .getUpcomingMovies(let page), .getPopularMovies(let page):
            return [
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "api_key", value: "\(apiKey)")
            ]
        case .getMovie:
            return [
                URLQueryItem(name: "api_key", value: "\(apiKey)")
            ]
        case .searchMovie(let query, let page):
            return [
                URLQueryItem(name: "query", value: query),
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "api_key", value: "\(apiKey)")
            ]
        }
    }
}

private func getAuthInfoFromPropertyList() -> String {
    let fileName = "Info"
    let propertyKey = "TMDB_API_KEY"

    guard let filePath = Bundle.main.path(forResource: fileName, ofType: "plist") else {
        fatalError("Couldn't find file '\(fileName).plist' on target root directory.")
    }
    guard let value = NSDictionary(contentsOfFile: filePath)?.object(forKey: propertyKey) as? String else {
        fatalError("Couldn't find key '\(propertyKey)' in '\(fileName).plist'.")
    }

    return value
}

