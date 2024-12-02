//
//  StoryLocalStorage.swift
//  HackerNews
//
//  Created by Carlos Llerena on 2/12/24.
//


struct StoryLocalStorage {

    @LocalStorageUserDefaults(key: "deletedStoryIDs", defaultValue: nil, container: .standard)
    public static var deletedStoryIDs: [String]?
    
}
