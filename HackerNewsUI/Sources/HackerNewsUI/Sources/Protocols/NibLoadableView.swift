//
//  NibLoadableView.swift
//  PagoCheveris
//
//  Created by Carlos Llerena on 1/12/24.
//

import UIKit

protocol NibLoadableView: AnyObject {
    
    @MainActor static var nib: UINib { get }
}

extension NibLoadableView {
    
    /**
     Adds the functionality of getting the Nib Name using the property nibName
     
     ### Usage Example: ###
     ````
     extension ViewCell: NibLoadableView {}
     
     ViewCell.nibName
     ````
     */
    static var nibName: String {
        String(describing: self)
    }
    
    //Instantiate a nib with the same name as the class and located in the same bundle as the class
    @MainActor static var nib: UINib {
        UINib(nibName: nibName, bundle: Bundle(for: self))
    }

}

extension NibLoadableView where Self: UIView {
    
    /**
     Returns a UIView Instantiated from a Nib
     
     ### Usage Example: ###
     ````
     extension NameOfView: NibLoadableView {}
     
     let view = NameOfClass.loadFromNib()
     ````
     */
    @MainActor static func loadFromNib() -> Self {
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? Self else {
            fatalError("The nib \(nib) whas not able to load successfully")
        }
        
        return view
    }
}
