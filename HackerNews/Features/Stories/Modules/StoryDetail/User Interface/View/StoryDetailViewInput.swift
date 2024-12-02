//
//  StoryDetailViewInput.swift
//  HackerNews
//
//  Created by Carlos on 02/12/2024.
//  Copyright © 2024 Carlos Llerena. All rights reserved.
//

protocol StoryDetailViewInput: AnyObject {

    func setUpInitialState()
    func moduleInput() -> StoryDetailModuleInput
    func loadWebView(with url: String, title: String)
}
