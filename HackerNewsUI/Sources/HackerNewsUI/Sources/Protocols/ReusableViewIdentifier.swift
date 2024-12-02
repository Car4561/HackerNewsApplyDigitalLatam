//
//  ReusableViewIdentifier.swift
//  PagoCheveris
//
//  Created by Carlos Llerena on 1/12/24.
//

import UIKit

/**
 Adds the functionality of a variable called reuseIdentifier to any UIView that conforms to this protocol.
 It is assumed that the reuseidentifier placed on the Storyboard has the same name as the class that is conforming to it.
 
 ### Usage Example: ###
 ````
 extension ViewCell: ReusableViewIdentifier {}
 
 ViewCell.reuseIdentifier
 ````
 */
protocol ReusableViewIdentifier: AnyObject {
    
    static var reuseIdentifier: String { get }
}

extension ReusableViewIdentifier where Self: UIView {
    
    static var reuseIdentifier: String {
        String(describing: self)
    }
}
