//
//  LocalStorageUserDefaults.swift
//  HackerNews
//
//  Created by Carlos Llerena on 2/12/24.
//

import Foundation

@propertyWrapper
public struct LocalStorageUserDefaults<Value> {
    
    let key: String
    let defaultValue: Value
    var container: UserDefaults = UserDefaults.standard
    
    public var wrappedValue: Value {
        get {
            return container.object(forKey: key) as? Value ?? defaultValue
        }
        
        set {
            if let optional = newValue as? AnyOptional, optional.isNil {
                container.removeObject(forKey: key)
            } else {
                container.set(newValue, forKey: key)
            }
        }
    }
    
    public init(key: String, defaultValue: Value, container: UserDefaults) {
        self.key = key
        self.defaultValue = defaultValue
        self.container = container
    }
}

extension LocalStorageUserDefaults where Value: ExpressibleByNilLiteral {
    
    public init(key: String, _ container: UserDefaults = .standard) {
        self.init(key: key, defaultValue: nil, container: container)
    }
}
