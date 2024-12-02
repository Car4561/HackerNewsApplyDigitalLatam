//
//  StoryDetailPresenterTest.swift
//  HackerNews
//
//  Created by Carlos on 02/12/2024.
//  Copyright © 2024 Carlos Llerena. All rights reserved.
//

import Nimble
import Quick

@testable import HackerNews

final class StoryDetailPresenterTest: QuickSpec {

    override func spec() {
        beforeEach {
        }

        afterEach {
        }

        describe("A StoryDetail Presenter") {
        }
    }


    // MARK: Mock Classes

    private class MockInteractor: StoryDetailInteractorInput {
    }

    private class MockRouter: StoryDetailRouterInput {
    }

    private class MockView: StoryDetailViewInput {

        func setUpInitialState() {
        }

        func moduleInput() -> StoryDetailModuleInput {

            return StoryDetailPresenter()
	    }
    }
}
