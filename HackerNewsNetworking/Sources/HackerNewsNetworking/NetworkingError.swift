//
//  NetworkingError.swift
//  
//
//  Created by Carlos Llerena on 1/12/24.
//

public enum NetworkingError: Error {
    
    case apiError(error: Decodable & Sendable)
    case notConnectionInternet(Error)
    case invalidRequestError(String)
    case invalidResponse
    case parsingError(Error, String)
    case unauthorized
    case unexpectedError(Error)
}
