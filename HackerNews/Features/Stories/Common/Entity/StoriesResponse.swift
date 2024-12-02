//
//  StoriesResponse.swift
//  HackerNews
//
//  Created by Carlos Llerena on 2/12/24.
//

import Foundation

// MARK: - StoriesResponse
struct StoriesResponse: Codable {
    let exhaustive: Exhaustive
    let exhaustiveNbHits, exhaustiveTypo: Bool
    let stories: [Story]
    let hitsPerPage, nbHits, nbPages, page: Int
    let params: String
    let processingTimeMS: Int
    let processingTimingsMS: ProcessingTimingsMS
    let query: Query
    let serverTimeMS: Int
    
    enum CodingKeys: String, CodingKey {
        case exhaustive
        case exhaustiveNbHits
        case exhaustiveTypo
        case stories = "hits"
        case hitsPerPage
        case nbHits
        case nbPages
        case page
        case params
        case processingTimeMS
        case processingTimingsMS
        case query
        case serverTimeMS
    }
    
}

// MARK: - Exhaustive
struct Exhaustive: Codable {
    let nbHits, typo: Bool
}

// MARK: - Hit
struct Story: Codable {
    var highlightResult: HighlightResult?
    var tags: [String]?
    let author: String
    var commentText: String?
    let createdAt: Date
    var createdAtI: Int?
    let id: String
    var parentID: Int?
    var storyID: Int?
    var storyTitle: String?
    var storyURL: String?
    var updatedAt: Date?
    var numComments, points: Int?
    var title: String?
    var url: String?
    var children: [Int]?
    var storyText: String?
    
    var finalTitle: String {
        return title ?? storyTitle ?? "Sin título"
    }
    
    var finalUrl: String {
        return url ?? storyURL ?? "Sin URL"
    }

    enum CodingKeys: String, CodingKey {
        case highlightResult = "_highlightResult"
        case tags = "_tags"
        case author
        case commentText = "comment_text"
        case createdAt = "created_at"
        case createdAtI = "created_at_i"
        case id = "objectID"
        case parentID = "parent_id"
        case storyID = "story_id"
        case storyTitle = "story_title"
        case storyURL = "story_url"
        case updatedAt = "updated_at"
        case numComments = "num_comments"
        case points, title, url, children
        case storyText = "story_text"
    }
    
    init(id: String, author: String, createdAt: Date, title: String?, url: String?) {
        self.id = id
        self.author = author
        self.createdAt = createdAt
        self.title = title
        self.url = url
    }
}

// MARK: - HighlightResult
struct HighlightResult: Codable {
    let author: Author
    let commentText, storyTitle, storyURL, title: Author?
    let url, storyText: Author?

    enum CodingKeys: String, CodingKey {
        case author
        case commentText = "comment_text"
        case storyTitle = "story_title"
        case storyURL = "story_url"
        case title, url
        case storyText = "story_text"
    }
}

// MARK: - Author
struct Author: Codable {
    let matchLevel: MatchLevel
    let matchedWords: [Query]
    let value: String
    let fullyHighlighted: Bool?
}

enum MatchLevel: String, Codable {
    case full = "full"
    case none = "none"
}

enum Query: String, Codable {
    case mobile = "mobile"
}

// MARK: - ProcessingTimingsMS
struct ProcessingTimingsMS: Codable {
    let request: Request
    let afterFetch: AfterFetch
    let fetch: Fetch
    let total: Int

    enum CodingKeys: String, CodingKey {
        case request = "_request"
        case afterFetch, fetch, total
    }
}

// MARK: - AfterFetch
struct AfterFetch: Codable {
    let format: Format
}

// MARK: - Format
struct Format: Codable {
    let total: Int
}

// MARK: - Fetch
struct Fetch: Codable {
    let query, total: Int
}

// MARK: - Request
struct Request: Codable {
    let roundTrip: Int
}
