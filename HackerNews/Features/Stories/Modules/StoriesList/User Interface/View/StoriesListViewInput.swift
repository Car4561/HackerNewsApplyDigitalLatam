//
//  StoriesListViewInput.swift
//  HackerNews
//
//  Created by Carlos on 02/12/2024.
//  Copyright © 2024 Carlos Llerena. All rights reserved.
//

protocol StoriesListViewInput: AnyObject {

    func setUpInitialState()
    func moduleInput() -> StoriesListModuleInput
    func reloadStories()
    func endRefreshing()
}
