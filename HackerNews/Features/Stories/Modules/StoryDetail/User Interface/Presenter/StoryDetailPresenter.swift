//
//  StoryDetailPresenter.swift
//  HackerNews
//
//  Created by Carlos on 02/12/2024.
//  Copyright © 2024 Carlos Llerena. All rights reserved.
//

class StoryDetailPresenter {

    weak var view: StoryDetailViewInput!
    var interactor: StoryDetailInteractorInput!
    var router: StoryDetailRouterInput!

    private var story: Story!
}


// MARK: StoryDetailModuleInput methods

extension StoryDetailPresenter: StoryDetailModuleInput {

    func initializeModule(story: Story) {
        self.story = story
    }
}


// MARK: StoryDetailViewOutput methods

extension StoryDetailPresenter: StoryDetailViewOutput {

    func viewIsReady() {
        view.loadWebView(with: story.finalUrl, title: story.finalTitle)
    }
}


// MARK: StoryDetailInteractorOutput methods

extension StoryDetailPresenter: StoryDetailInteractorOutput {
}
