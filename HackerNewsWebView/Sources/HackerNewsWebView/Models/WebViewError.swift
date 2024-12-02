//
//  WebViewError.swift
//  HackerNewsWebView
//
//  Created by Carlos Llerena on 2/12/24.
//

public struct BaseWebViewError {
        
    public let code: BaseWebViewErrorCode
    public let description: String
    
}

public enum BaseWebViewErrorCode: Int {
    
    case invalidURL = 1
    case networkError = 2
    case other = 3
    
}
