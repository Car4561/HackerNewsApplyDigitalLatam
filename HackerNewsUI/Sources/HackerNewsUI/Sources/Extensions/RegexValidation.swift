//
//  RegexValidation.swift
//  
//
//  Created by Carlos Llerena on 1/12/24.
//

import Foundation

extension String {
    
    public func isValid(regex: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        let isValid = predicate.evaluate(with: self)
        return isValid
    }
}
