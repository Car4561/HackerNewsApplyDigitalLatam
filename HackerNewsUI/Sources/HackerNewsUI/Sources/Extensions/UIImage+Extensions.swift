//
//  UIImage+Extensions.swift
//
//
//  Created by Carlos Llerena on 1/12/24.
//

import UIKit

extension UIImage {
    
    static func loadImage(named: String) -> UIImage {
        guard let image = UIImage(named: named, in: Bundle.module, compatibleWith: nil) else { abort() }
        return image
    }
}
