//
//  MovieDetailsEndpoint.swift
//  MovieApp
//
//  Created by esundaram esundaram on 09/02/23.
//

import Foundation

enum MovieDetailsEndpoint {
    case getMovie(id: Int)
}

extension MovieDetailsEndpoint: Endpoint {
    var path: String {
        switch self {
        case .getMovie(let id):
            return "/movie/\(id)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getMovie:
            return .get
        }
    }
    
    var queryParams: [URLQueryItem] {
        return [
            URLQueryItem(name: "api_key", value: "0e7274f05c36db12cbe71d9ab0393d47")
        ]
    }
}
