//
//  StoriesListRouter.swift
//  HackerNews
//
//  Created by Carlos on 02/12/2024.
//  Copyright © 2024 Carlos Llerena. All rights reserved.
//

class StoriesListRouter: StoriesListRouterInput, Routable {
    
    weak var viewController: StoriesListViewController!

    func routeToStoryDetail(with story: Story) {
        pushViewController(
            from: viewController,
            to: StoryDetailViewController.self,
            configuration: StoryDetailModuleConfigurator.self
        ) { storyDetailViewController in
            storyDetailViewController.moduleInput().initializeModule(story: story)
        }
    }
}
