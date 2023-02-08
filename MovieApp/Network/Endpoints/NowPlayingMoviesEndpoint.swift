//
//  NowPlayingMoviesEndpoint.swift
//  MovieApp
//
//  Created by esundaram esundaram on 08/02/23.
//

import Foundation

enum NowPlayingMoviesEndpoint {
    case getNowPlayingMovies(page: Int)
}

extension NowPlayingMoviesEndpoint: Endpoint {
    var path: String {
        switch self {
        case .getNowPlayingMovies:
            return "/movie/now_playing"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getNowPlayingMovies:
            return .get
        }
    }
    
    var queryParams: [URLQueryItem] {
        switch self {
        case .getNowPlayingMovies(let page):
            return [
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "api_key", value: "0e7274f05c36db12cbe71d9ab0393d47")
            ]
        }
    }
}

