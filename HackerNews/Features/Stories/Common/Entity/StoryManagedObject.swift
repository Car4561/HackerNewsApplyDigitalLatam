//
//  StoryManagedObject.swift
//  HackerNews
//
//  Created by Carlos Llerena on 2/12/24.
//

import CoreData

class StoryManagedObject: NSManagedObject {

    @NSManaged var id: String
    @NSManaged var title: String
    @NSManaged var url: String
    @NSManaged var author: String
    @NSManaged var createdAt: Date
}

