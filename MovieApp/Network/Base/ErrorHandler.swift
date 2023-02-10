//
//  ErrorHandler.swift
//  MovieApp
//
//  Created by esundaram esundaram on 08/02/23.
//

import Foundation

enum ErrorHandler: Error {
    case decode
    case invalidURL
    case invalidData
    case noResponse
    case unauthorized
    case notFound
    case unexpectedStatusCode
    case badRequest
    case serverError
    case unknown
    
    var customMessage: String {
        switch self {
        case .decode:
            return "We have a little problem decoding data."
        case .invalidURL:
            return "You are trying to fetch a invalid URL."
        case .invalidData:
            return "You get a invalid response from the server"
        case .noResponse:
            return "We're having trouble loading this content, \n  please try again."
        case .badRequest:
            return "Bad request! Request is Invalid"
        case .unauthorized:
            return "401: No authorization! Please check if you have a valid API secret key."
        case .notFound:
            return "404: The URL that you are trying to fetch doesn't exist."
        case .serverError:
            return "500:  Internal [RIP] Server Error"
        case .unexpectedStatusCode:
            return "We're having trouble loading this content, \n  please try again."
        default:
            return "Unknown error"
        }
    }
}
