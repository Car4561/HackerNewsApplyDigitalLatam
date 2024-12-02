//
//  StoryDetailViewTest.swift
//  HackerNews
//
//  Created by Carlos on 02/12/2024.
//  Copyright © 2024 Carlos Llerena. All rights reserved.
//

import Nimble
import Quick

@testable import HackerNews

final class StoryDetailViewTest: QuickSpec {

    override func spec() {
        beforeEach {
        }

        afterEach {
        }

        describe("A StoryDetail View") {
        }
    }


    // MARK: Mock Classes

    private class MockOutput: StoryDetailViewOutput {

        var viewIsReadyCount = 0

        func viewIsReady() {
            viewIsReadyCount += 1
        }
    }
}
