//
//  AnyOptional.swift
//  HackerNews
//
//  Created by Carlos Llerena on 2/12/24.
//

protocol AnyOptional {
    
    var isNil: Bool { get }
}

extension Optional: AnyOptional {
    
    var isNil: Bool { self == nil }
}
