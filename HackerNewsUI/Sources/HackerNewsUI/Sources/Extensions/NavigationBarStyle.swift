//
//  File.swift
//  
//
//  Created by Carlos Llerena on 1/12/24.
//

import UIKit

public protocol NavigationBarStyle {
    
    func primaryStyle()
    func clearStyle()
}

public extension NavigationBarStyle where Self: UIViewController {
    
    @MainActor func clearStyle() {
        let appearance = UINavigationBarAppearance()
        
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationItem.backButtonTitle = ""
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    @MainActor func primaryStyle() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = HNColors.tintedNavigationBar
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : HNColors.tintedNavigationBarItem]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = HNColors.tintedNavigationBarItem
        navigationItem.backButtonTitle = ""
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
}
