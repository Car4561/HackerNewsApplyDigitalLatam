//
//  StoryDetailConfiguratorTest.swift
//  HackerNews
//
//  Created by Carlos on 02/12/2024.
//  Copyright © 2024 Carlos Llerena. All rights reserved.
//

import Nimble
import Quick

@testable import HackerNews

final class StoryDetailModuleConfiguratorTest: QuickSpec {

    override func spec() {
        var viewController: StoryDetailViewControllerMock!

        beforeEach {
            viewController = StoryDetailViewControllerMock()

            StoryDetailModuleConfigurator.configure(viewController: viewController)
        }

        afterEach {
            viewController = nil
            configurator = nil
        }

        describe("A StoryDetailModuleConfigurator") {
            it("should configure the viewController") {
                expect(viewController.output).toNot(beNil())
                expect(viewController.output).to(beAKindOf(StoryDetailPresenter.self))
            }

            it("should configure the presenter") {
                let presenter = viewController.output as? StoryDetailPresenter

                expect(presenter?.view).toNot(beNil())
                expect(presenter?.view).to(beAKindOf(StoryDetailViewController.self))

                expect(presenter?.router).toNot(beNil())
                expect(presenter?.router).to(beAKindOf(StoryDetailRouter.self))

                expect(presenter?.interactor).toNot(beNil())
                expect(presenter?.interactor).to(beAKindOf(StoryDetailInteractor.self))
            }

            it("should configure the interactor") {
                let presenter = viewController.output as? StoryDetailPresenter
                let interactor = presenter?.interactor as? StoryDetailInteractor

                expect(interactor?.output).toNot(beNil())
                expect(interactor?.output).to(beAKindOf(StoryDetailPresenter.self))
            }
        }
    }


    // MARK: Mock Classes

    private class StoryDetailViewControllerMock: StoryDetailViewController {
    }
}
