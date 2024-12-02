//
//  StoriesListInteractorInput.swift
//  HackerNews
//
//  Created by Carlos on 02/12/2024.
//  Copyright © 2024 Carlos Llerena. All rights reserved.
//

protocol StoriesListInteractorInput {
    
    func getStoriesList()
    func deleteStory(id: String)
}
