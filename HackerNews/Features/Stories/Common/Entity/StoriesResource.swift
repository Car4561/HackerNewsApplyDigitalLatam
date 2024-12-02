//
//  StoriesResource.swift
//  HackerNews
//
//  Created by Carlos Llerena on 2/12/24.
//

import HackerNewsNetworking

enum StoriesResource: Resource {

    case recipes

    var resource: (method: HTTPMethod, route: String) {
        switch self {
        case .recipes:
            return (.get, "/search_by_date?query=mobile")
        }
    }
}
