//
//  UITableView+Extensions.swift
//  PagoCheveris
//
//  Created by Carlos Llerena on 1/12/24.
//

import UIKit

extension UITableViewCell: ReusableViewIdentifier {}

extension UITableView {

    public func register<T: UITableViewCell>(_: T.Type) {
        register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
    }

    public func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            preconditionFailure("Could not dequeue cell with identifier: \(T.reuseIdentifier)")
        }
        
        return cell
    }
}
