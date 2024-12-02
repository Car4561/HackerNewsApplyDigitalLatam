//
//  ClientConfiguration.swift
//  
//
//  Created by Carlos Llerena on 1/12/24.
//

public typealias HTTPHeaders = [String: String]

public struct ClientConfiguration {
    
    let baseURL: String
    let httpHeaders: HTTPHeaders
    
    public init(baseURL: String, httpHeaders: HTTPHeaders) {
        self.baseURL = baseURL
        self.httpHeaders = httpHeaders
    }
}
