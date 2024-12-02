//
//  StoriesListInteractor.swift
//  HackerNews
//
//  Created by Carlos on 02/12/2024.
//  Copyright © 2024 Carlos Llerena. All rights reserved.
//

import Foundation
import Combine

class StoriesListInteractor: StoriesListInteractorInput {
    
    weak var output: StoriesListInteractorOutput!
    
    let storiesClient: StoriesClientProvider
    let coreDataService: CoreDataProvider
    var cancellables: Set<AnyCancellable> = []
    
    private let deletedStoryIDsKey = "DeletedStoryIDs"
    private var deletedStoryIDs: [String] { UserDefaults.standard.array(forKey: deletedStoryIDsKey) as? [String] ?? [] }
    
    init(storiesClient: StoriesClientProvider, coreDataService: CoreDataProvider) {
        self.storiesClient = storiesClient
        self.coreDataService = coreDataService
    }
    
    func getStoriesList() {
        storiesClient.recipesList()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self else { return }
                switch completion {
                case .failure(let networkingError):
                    switch networkingError {
                    case .apiError:
                        self.output.didFailFetchingStoriesList()
                    case .notConnectionInternet:
                        self.loadStoriesFromLocalCache()
                    case .unexpectedError:
                        self.output.didFailFetchingStoriesList()
                    default:
                        self.output.didFailFetchingStoriesList()
                        break
                    }
                default:
                    break
                }
            }, receiveValue: { [weak self] response in
                guard let self else { return }
                let filteredStories = response.stories.filter { !(StoryLocalStorage.deletedStoryIDs ?? []).contains($0.id) }
                self.saveStoriesList(storiesList: filteredStories)
                self.output.didFetchStoriesList(storiesList: filteredStories)
            }).store(in: &cancellables)
    }
    
    func deleteStory(id: String) {
        saveDeletedStoryID(id)
        let predicate = NSPredicate(format: "SELF.id == %@", id)
        if let storyToDelete = coreDataService.fetch(StoryManagedObject.self, query: predicate, sortDescriptors: nil, fetchLimit: 1)?.first {
            coreDataService.delete(storyToDelete)
        }
        saveDeletedStoryID(id)
    }
    
    private func saveStoriesList(storiesList: [Story]) {
        storiesList.forEach { story in
            guard let storyDataObject = coreDataService.add(StoryManagedObject.self) else {
                return
            }
            storyDataObject.title = story.finalTitle
            storyDataObject.url = story.finalUrl
            storyDataObject.author = story.author
            storyDataObject.createdAt = story.createdAt
        }
        coreDataService.save()
    }
    
    private func loadStoriesFromLocalCache() {
        let deletedIDs = StoryLocalStorage.deletedStoryIDs ?? []
        let cachedStories: [HackerNews.StoryManagedObject]? = coreDataService.fetch(StoryManagedObject.self, query: nil, sortDescriptors: nil, fetchLimit: 0)
        let stories = cachedStories?.compactMap { storyObject -> Story? in
            guard !deletedIDs.contains(storyObject.id) else {
                return nil
            }
            return Story(
                id: storyObject.id,
                author: storyObject.author,
                createdAt: storyObject.createdAt,
                title: storyObject.title,
                url: storyObject.url
            )
        } ?? []
        output.didFetchStoriesList(storiesList: stories)
    }
    
    private func saveDeletedStoryID(_ id: String) {
        var deletedIDs = StoryLocalStorage.deletedStoryIDs ?? []
        if !deletedIDs.contains(id) {
            deletedIDs.append(id)
            StoryLocalStorage.deletedStoryIDs = deletedIDs
        }
    }
    
}
