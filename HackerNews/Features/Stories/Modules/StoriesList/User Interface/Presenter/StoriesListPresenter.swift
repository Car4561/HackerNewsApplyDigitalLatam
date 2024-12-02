//
//  StoriesListPresenter.swift
//  HackerNews
//
//  Created by Carlos on 02/12/2024.
//  Copyright © 2024 Carlos Llerena. All rights reserved.
//

class StoriesListPresenter {

    weak var view: StoriesListViewInput!
    var interactor: StoriesListInteractorInput!
    var router: StoriesListRouterInput!
    
    private var storiesList: [Story] = []
    private var isRefreshing = false
    
    private func finishRefreshingIfNeeded() {
        if isRefreshing {
            view.endRefreshing()
            isRefreshing = false
        }
    }
}


// MARK: StoriesListModuleInput methods

extension StoriesListPresenter: StoriesListModuleInput {

    func initializeModule() {
        
    }
}


// MARK: StoriesListViewOutput methods

extension StoriesListPresenter: StoriesListViewOutput {
    
    var storiesListCount: Int {
        storiesList.count
    }
    
    func getStory(at index: Int) -> Story {
        storiesList[index]
    }
    

    func viewIsReady() {
        interactor.getStoriesList()
    }
    
    func didTapStory(at index: Int) {
        let story = storiesList[index]
        router.routeToStoryDetail(with: story)
    }
    
    func didTapDeleteStory(at index: Int) {
        let storyID = storiesList[index].id
        storiesList.remove(at: index)
        view.reloadStories()
        interactor.deleteStory(id: storyID)
    }
    
    func didTriggerRefresh() {
        isRefreshing = true
        interactor.getStoriesList()
    }
}


// MARK: StoriesListInteractorOutput methods

extension StoriesListPresenter: StoriesListInteractorOutput {

    func didFetchStoriesList(storiesList: [Story]) {
        self.storiesList = storiesList
        view.reloadStories()
        finishRefreshingIfNeeded()
    }
    
    func didFailFetchingStoriesList() {
        finishRefreshingIfNeeded()
    }
    
}
