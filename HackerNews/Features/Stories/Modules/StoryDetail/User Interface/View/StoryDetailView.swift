//
//  StoryDetailView.swift
//  HackerNews
//
//  Created by Carlos Llerena on 2/12/24.
//

import UIKit
import HackerNewsWebView

extension StoryDetailViewController {

    final class CustomView: UIView {
        
        // MARK: - Views
        
        private(set) var webView: WebView = {
            let webView = WebView()
            webView.translatesAutoresizingMaskIntoConstraints = false
            return webView
        }()
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            initializeView()
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            initializeView()
        }
        
        // MARK: - Functions
        
        func initializeView() {
            backgroundColor = .white
            addSubview(webView)
            webView.pinToSafeAreaSuperview()
        }
        
    }
    
    
}
