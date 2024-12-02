//
//  StoriesClient.swift
//  HackerNews
//
//  Created by Carlos Llerena on 2/12/24.
//

import HackerNewsNetworking
import Combine

protocol StoriesClientProvider {
    func recipesList() -> AnyPublisher<StoriesResponse, NetworkingError>
}

final class StoriesClient: RestClient, StoriesClientProvider {

    func recipesList() -> AnyPublisher<StoriesResponse, NetworkingError> {
        request(
            resource: StoriesResource.recipes,
            type: StoriesResponse.self,
            errorType: ErrorResponse.self
        )
    }
}
