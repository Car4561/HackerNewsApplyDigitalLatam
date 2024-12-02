//
//  StoryDetailConfigurator.swift
//  HackerNews
//
//  Created by Carlos on 02/12/2024.
//  Copyright © 2024 Carlos Llerena. All rights reserved.
//

import UIKit

class StoryDetailModuleConfigurator: ModuleConfigurator {

    static func configure(viewController: UIViewController) {
        guard let viewController = viewController as? StoryDetailViewController else { return }
    
        let router = StoryDetailRouter()

        let presenter = StoryDetailPresenter()
        presenter.view = viewController
        presenter.router = router

        let interactor = StoryDetailInteractor()
        interactor.output = presenter

        presenter.interactor = interactor
        viewController.output = presenter
    }
}
