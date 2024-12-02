//
//  StoriesListPresenterTest.swift
//  HackerNews
//
//  Created by Carlos on 02/12/2024.
//  Copyright © 2024 Carlos Llerena. All rights reserved.
//

import Nimble
import Quick

@testable import HackerNews

final class StoriesListPresenterTest: QuickSpec {

    override func spec() {
        beforeEach {
        }

        afterEach {
        }

        describe("A StoriesList Presenter") {
        }
    }


    // MARK: Mock Classes

    private class MockInteractor: StoriesListInteractorInput {
    }

    private class MockRouter: StoriesListRouterInput {
    }

    private class MockView: StoriesListViewInput {

        func setUpInitialState() {
        }

        func moduleInput() -> StoriesListModuleInput {

            return StoriesListPresenter()
	    }
    }
}
