//
//  NetworkingService.swift
//  YapeChallenge
//
//  Created by Carlos Llerena on 1/12/24.
//

import Foundation
import HackerNewsNetworking

final class NetworkingService {
    
    // MARK: Properties

    var configuration: ClientConfiguration {
        return makeConfiguration()
    }
    
    // MARK: Private methods
    
    private func makeConfiguration() -> ClientConfiguration {
        let configuration = ClientConfiguration(
            baseURL: makeHost(),
            httpHeaders: makeHeaders()
        )
        return configuration
    }

    private func makeHost() -> String {
       return Host.baseUrl
    }

    private func makeHeaders() -> [String: String] {
        ["Content-Type" : "application/json"]
    }
    
}
