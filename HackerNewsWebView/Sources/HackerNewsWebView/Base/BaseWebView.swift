//
//  BaseWebView.swift
//
//  Created by Carlos Llerena on 2/12/24.
//

import UIKit
import WebKit

public class BaseWebView: WKWebView {
    
    public var interfaceName: String = "MobileInterface"
    public var urlString: String = ""
    
    private var headers: [String: String]?
    private var domain: String?
    private var jsonData: String?
    
    // MARK: - Lifecycle

    public override init(frame: CGRect, configuration: WKWebViewConfiguration = WKWebViewConfiguration()) {
        super.init(frame: frame, configuration: configuration)
        setupConfiguration(configuration: configuration)
    }
   
    public init(
        frame: CGRect,
        configuration: WKWebViewConfiguration = WKWebViewConfiguration(),
        interfaceName: String
    ) {
        super.init(frame: frame, configuration: configuration)
        self.interfaceName = interfaceName
        setupConfiguration(configuration: configuration)
    }

    public init() {
        let configuration = WKWebViewConfiguration.noPersistent
        super.init(frame: .zero, configuration: configuration)
        self.interfaceName = "iOSInterface"
        self.scrollView.bounces = false
        self.scrollView.showsVerticalScrollIndicator = false
        setupConfiguration(configuration: configuration)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    
    open func handleWebViewError(with error: BaseWebViewError) {}
        
    open func handleOpeningExternalURL(_ url: URL) {}

    open func handleScriptMessage(_ message: WKScriptMessage) {}
    
    open func handleStatusCode(statusCode: Int) {}
    
    public func config(
        url: String,
        headers: Dictionary<String, String>? = nil,
        domain: String? = nil
    ) {
        self.urlString = url
        self.headers = headers
        self.domain = domain
        loadUrl()
    }

    public func config(
        url: String,
        html: String,
        domain: String? = nil
    ) {
        self.domain = domain
        self.loadHTMLString(html, baseURL: URL(string: url))
    }

    public func config(
        url: String,
        json: String,
        domain: String? = nil
    ) {
        self.urlString = url
        self.domain = domain
        jsonData = json
        loadUrl()
    }
    
    public func removeWebView() {
        configuration.userContentController.removeScriptMessageHandler(forName: interfaceName)
    }
    
    public func backPressed() {
        evaluateJavaScript("\(interfaceName).goBack();")
    }
    
    public func sendMessage(jsonData: String) {
        evaluateJavaScript("handleIncomingMessage('\(jsonData)')")
    }
    
    // MARK: - Private functions
    
    private func setupConfiguration(configuration: WKWebViewConfiguration) {
        configuration.userContentController.add(self, name: interfaceName)
        self.navigationDelegate = self
        enableJavascript()
        guard let _ = URL(string: self.urlString) else {
            invalidUrl()
            return
        }
    }
    
    /// Function to enable Javascript for the webview to handle.
    /// - Different implementations found, according to the OS version of the device.
    private func enableJavascript() {
        if #available(iOS 14.0, *) {
            let webpagePreferences = WKWebpagePreferences()
            webpagePreferences.allowsContentJavaScript = true
            self.configuration.defaultWebpagePreferences = webpagePreferences
        } else {
            let preferences = WKPreferences()
            preferences.javaScriptEnabled = true
            self.configuration.preferences = preferences
        }
    }
    
    /// Function to load url preloaded in the urlString property.
    private func loadUrl() {
        guard let link = URL(string: self.urlString) else {
            invalidUrl()
            return
        }
        var request = URLRequest(url: link)
        headers?.forEach { (key, value) in request.addValue(value, forHTTPHeaderField: key) }
        self.load(request)
    }
    
    /// Function to check if an invalid URL was set.
    private func invalidUrl() {
        handleWebViewError(with: BaseWebViewError(code: .invalidURL, description: "Invalid URL: \(self.urlString)"))
    }
        
}

// MARK: - WKNavigationDelegate

extension BaseWebView: WKNavigationDelegate {
    
    public func webView(
        _ webView: WKWebView,
        didFailProvisionalNavigation navigation: WKNavigation!,
        withError error: Error
    ) {
        if let networkError = error as NSError?, networkError.code == NSURLErrorNotConnectedToInternet {
            handleWebViewError(with: BaseWebViewError(code: .networkError, description: "Not connected to internet"))
        }
    }
    
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {}
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        guard let jsonData else { return }
        sendMessage(jsonData: jsonData)
        self.jsonData = nil
    }
    
    /// - In the implementation of the decidePolicyForNavigationAction, we consider the domain to lock webview to lock other domains.
    public func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        guard let url = navigationAction.request.url else {
            decisionHandler(.cancel)
            return
        }
        handleOpeningExternalURL(url)
        if let domain = self.domain, let host = url.host {
            if domain.range(of: host) != nil {
                decisionHandler(.allow)
            } else {
                decisionHandler(.cancel)
            }
        } else {
            decisionHandler(.allow)
        }
    }
    
    public func webView(_ webView: WKWebView,
                        decidePolicyFor navigationResponse: WKNavigationResponse) async -> WKNavigationResponsePolicy {
        guard let response = navigationResponse.response as? HTTPURLResponse else { return .allow}
        handleStatusCode(statusCode: response.statusCode)
        return .allow
    }
    
}

// MARK: - WKScriptMessageHandler

extension BaseWebView: WKScriptMessageHandler {
    
    /// - Implementation of the userContentControllerDidReceiveMessage to recognize custom Javascript calls
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        handleScriptMessage(message)
    }
    
}
