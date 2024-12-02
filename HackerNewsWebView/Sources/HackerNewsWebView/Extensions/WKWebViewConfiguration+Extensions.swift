//
//  File.swift
//  
//
//  Created by Carlos Llerena on 2/12/24.
//

import WebKit

public extension WKWebViewConfiguration {
    
    static var noPersistent: WKWebViewConfiguration {
        let config = WKWebViewConfiguration()
        config.websiteDataStore = WKWebsiteDataStore.nonPersistent()
        return config
    }
    
}
