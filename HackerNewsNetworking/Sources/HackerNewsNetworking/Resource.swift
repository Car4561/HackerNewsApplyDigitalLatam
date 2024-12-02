//
//  Resource.swift
//  
//
//  Created by Carlos Llerena on 1/12/24.
//

public protocol Resource {
    
    var resource: (method: HTTPMethod, route: String) { get }
}
