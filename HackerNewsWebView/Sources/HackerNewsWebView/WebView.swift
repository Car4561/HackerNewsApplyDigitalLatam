//
//  WebViewDelegate.swift
//  HackerNewsWebView
//
//  Created by Carlos Llerena on 2/12/24.
//

import Foundation
import WebKit

public protocol WebViewDelegate: AnyObject {
    
    func webViewError(_ error: BaseWebViewError)
    func handleOpeningExternalURL(_ url: URL)
    func showLoading(_ show: Bool, currentStep: String)
    func navigate(
        with destination: String?,
        currentStep: String,
        additionalData: [String: Any]?
    )
    func openAddress(_ address: String?, currentStep: String)
    func handleButtonAction(
        with destination: String?,
        currentStep: String,
        buttonType: String
    )
    func downloadPdf(with base64Img: String?, currentStep: String)
    func downloadFile(with base64File: String?, currentStep: String)
    func hideBackButton(with enable: Bool, currentStep: String)

}

public class WebView: BaseWebView {
    
    // MARK: - Properties
    
    public weak var delegate: WebViewDelegate?
    
    // MARK: - Functions
   
    public override func handleWebViewError(with error: BaseWebViewError) {
        delegate?.webViewError(error)
    }
    
    public override func handleOpeningExternalURL(_ url: URL) {
        delegate?.handleOpeningExternalURL(url)
    }
    
    /// This override decodes the JSON data received from JavaScript  based on the message content.
    /// - Parameter message: The message object containing the JavaScript message data.
    public override func handleScriptMessage(_ message: WKScriptMessage) {
        if message.name == interfaceName {
            guard
                let jsonString = message.body as? String,
                let jsonData = jsonString.data(using: .utf8),
                let webData = try? JSONDecoder().decode(WebViewEvent.self, from: jsonData)
            else {
                delegate?.webViewError(BaseWebViewError(code: .other, description: "Error parsing webview data"))
                return
            }
            guard let webViewAction = ActionType(rawValue: webData.event.action) else { return }
            switch webViewAction {
            case .loader:
                handleLoader(webData: webData.event)
            case .navigation:
                handleNavigation(webData: webData.event)
            case .understandButton:
                handleUnderstandButton(webData: webData.event)
            case .redirect:
                handleRedirect(webData: webData.event)
            case .errorModalChannel:
                handleErrorModalChannel(webData: webData.event)
            case .navigationChannel:
                handleNavigationChannel(webData: webData.event)
            case .downloadPdf:
                handleDownloadPdf(webData: webData.event)
            case .downloadFile:
                handleDownloadFile(webData: webData.event)
            case .hideBackButton:
                handleHideBackButton(webData: webData.event)
            }
        }
    }
    
}

// MARK: - NewWebViewEvents

extension WebView {
    
    private func handleLoader(webData: WebViewData) {
        delegate?.showLoading(webData.data.isVisible ?? false, currentStep: webData.currentStep)
    }
    
    private func handleNavigation(webData: WebViewData) {
        delegate?.navigate(
            with: webData.data.goTo,
            currentStep: webData.currentStep,
            additionalData: webData.data.cardDelivery
        )
    }
    
    private func handleUnderstandButton(webData: WebViewData) {
        delegate?.handleButtonAction(
            with: webData.data.goTo,
            currentStep: webData.currentStep,
            buttonType: webData.data.type ?? ""
        )
    }
    
    private func handleRedirect(webData: WebViewData) {
        delegate?.openAddress(webData.data.goTo, currentStep: webData.currentStep)
    }
    
    private func handleErrorModalChannel(webData: WebViewData) {
        delegate?.navigate(
            with: webData.data.goTo,
            currentStep: webData.currentStep,
            additionalData: nil
        )
    }
    
    private func handleErrorModal(webData: WebViewData) {
        delegate?.navigate(
            with: webData.data.goTo,
            currentStep: webData.currentStep,
            additionalData: nil
        )
    }
    
    private func handleNavigationChannel(webData: WebViewData) {
        delegate?.navigate(
            with: webData.data.goTo,
            currentStep: webData.currentStep,
            additionalData: webData.data.cardDelivery
        )
    }
    
    private func handleDownloadPdf(webData: WebViewData) {
        delegate?.downloadPdf(with: webData.data.base64Img, currentStep: webData.currentStep)
    }
    
    private func handleDownloadFile(webData: WebViewData) {
        delegate?.downloadFile(with: webData.data.base64File, currentStep: webData.currentStep)
    }
    
    private func handleHideBackButton(webData: WebViewData) {
        delegate?.hideBackButton(with: webData.data.hideBackButton ?? false, currentStep: webData.currentStep)
    }
    
}
