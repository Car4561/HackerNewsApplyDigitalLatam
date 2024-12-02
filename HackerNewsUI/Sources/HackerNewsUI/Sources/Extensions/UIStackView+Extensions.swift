//
//  UIStackView+Extensions.swift
//  
//
//  Created by Carlos Llerena on 1/12/24.
//

import UIKit

public extension UIStackView {
    
    func addArrangedSubviews(_ views: UIView...) {
        views.forEach { addArrangedSubview($0) }
    }
}
