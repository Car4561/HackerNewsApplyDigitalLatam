//
//  StoriesListConfigurator.swift
//  HackerNews
//
//  Created by Carlos on 02/12/2024.
//  Copyright © 2024 Carlos Llerena. All rights reserved.
//

import UIKit

class StoriesListModuleConfigurator: ModuleConfigurator {

    static func configure(viewController: UIViewController) {
        guard let viewController = viewController as? StoriesListViewController else { return }
    
        let router = StoriesListRouter()
        router.viewController = viewController

        let presenter = StoriesListPresenter()
        presenter.view = viewController
        presenter.router = router

        let interactor = StoriesListInteractor(
            storiesClient: StoriesClient(configuration: NetworkingService().configuration),
            coreDataService: CoreDataService()
        )
        interactor.output = presenter

        presenter.interactor = interactor
        viewController.output = presenter
    }
}
