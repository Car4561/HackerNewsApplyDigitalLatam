//
//  StoriesListViewOutput.swift
//  HackerNews
//
//  Created by Carlos on 02/12/2024.
//  Copyright © 2024 Carlos Llerena. All rights reserved.
//

protocol StoriesListViewOutput {

    var storiesListCount: Int { get }

    func viewIsReady()
    func getStory(at index: Int) -> Story
    func didTapStory(at index: Int)
    func didTapDeleteStory(at index: Int)
    func didTriggerRefresh()
}
