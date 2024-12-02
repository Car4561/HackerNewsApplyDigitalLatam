//
//  StoryDetailViewController.swift
//  HackerNews
//
//  Created by Carlos on 02/12/2024.
//  Copyright © 2024 Carlos Llerena. All rights reserved.
//

import UIKit
import HackerNewsWebView

class StoryDetailViewController: UIViewController {

    var output: StoryDetailViewOutput!

    private var customView: CustomView {
        guard let view = view as? CustomView else {
            fatalError("Could not load Custom View")
        }
        return view
    }
    
    var webView: WebView { customView.webView }

    // MARK: Life cycle

    override func loadView() {
        view = CustomView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewIsReady()
    }
}


// MARK: StoryDetailViewInput Methods

extension StoryDetailViewController: StoryDetailViewInput {

    func setUpInitialState() {
    }

    func moduleInput() -> StoryDetailModuleInput {
        return output as! StoryDetailModuleInput
    }

    func loadWebView(with url: String, title: String) {
        self.title = title
        webView.config(url: url)
        webView.delegate = self
    }
}

extension StoryDetailViewController: WebViewDelegate {
    
    func webViewError(_ error: BaseWebViewError) {}
    
    func handleOpeningExternalURL(_ url: URL) {}
    
    func showLoading(_ show: Bool, currentStep: String) {}
    
    func navigate(with destination: String?, currentStep: String, additionalData: [String : Any]?) {}
    
    func openAddress(_ address: String?, currentStep: String) {}
    
    func handleButtonAction(with destination: String?, currentStep: String, buttonType: String) {}
    
    func downloadPdf(with base64Img: String?, currentStep: String) {}
    
    func downloadFile(with base64File: String?, currentStep: String) {}
    
    func hideBackButton(with enable: Bool, currentStep: String) {}
    
}
