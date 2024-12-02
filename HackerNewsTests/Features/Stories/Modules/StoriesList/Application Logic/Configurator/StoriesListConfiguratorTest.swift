//
//  StoriesListConfiguratorTest.swift
//  HackerNews
//
//  Created by Carlos on 02/12/2024.
//  Copyright © 2024 Carlos Llerena. All rights reserved.
//

import Nimble
import Quick

@testable import HackerNews

final class StoriesListModuleConfiguratorTest: QuickSpec {

    override func spec() {
        var viewController: StoriesListViewControllerMock!

        beforeEach {
            viewController = StoriesListViewControllerMock()

            StoriesListModuleConfigurator.configure(viewController: viewController)
        }

        afterEach {
            viewController = nil
            configurator = nil
        }

        describe("A StoriesListModuleConfigurator") {
            it("should configure the viewController") {
                expect(viewController.output).toNot(beNil())
                expect(viewController.output).to(beAKindOf(StoriesListPresenter.self))
            }

            it("should configure the presenter") {
                let presenter = viewController.output as? StoriesListPresenter

                expect(presenter?.view).toNot(beNil())
                expect(presenter?.view).to(beAKindOf(StoriesListViewController.self))

                expect(presenter?.router).toNot(beNil())
                expect(presenter?.router).to(beAKindOf(StoriesListRouter.self))

                expect(presenter?.interactor).toNot(beNil())
                expect(presenter?.interactor).to(beAKindOf(StoriesListInteractor.self))
            }

            it("should configure the interactor") {
                let presenter = viewController.output as? StoriesListPresenter
                let interactor = presenter?.interactor as? StoriesListInteractor

                expect(interactor?.output).toNot(beNil())
                expect(interactor?.output).to(beAKindOf(StoriesListPresenter.self))
            }
        }
    }


    // MARK: Mock Classes

    private class StoriesListViewControllerMock: StoriesListViewController {
    }
}
