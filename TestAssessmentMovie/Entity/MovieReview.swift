//
//  MovieReviews.swift
//  TestAssessmentMovie
//
//  Created by Chrismanto Natanail Manik on 24/10/23.
//

import Foundation

struct MovieReviewsResponse: Codable{
    var id: Int
    var page: Int
    var results: [MovieReview]
    var totalPages: Int
    var totalResults: Int
    
    enum CodingKeys: String, CodingKey{
        case id, page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct MovieReview: Codable, Hashable{
    var author: String
    var authorDetails: AuthorDetails
    var createdAt: String
    var content: String

    enum CodingKeys: String, CodingKey{
        case author, content
        case authorDetails = "author_details"
        case createdAt = "created_at"
    }
}

struct AuthorDetails: Codable, Hashable{
    var name: String?
    var username: String
    var avatarPath: String?
    var rating: Int?
    var imgURL: String{
        if let avatarPath = avatarPath{
            return "\(AppConfiguration().imagesBaseURL)\(avatarPath)"

        }
        return ""
    }
    enum CodingKeys: String, CodingKey{
        case name, username, rating
        case avatarPath = "avatar_path"
    }
}
