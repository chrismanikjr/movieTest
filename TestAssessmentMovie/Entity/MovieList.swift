//
//  MovieList.swift
//  TestAssessmentMovie
//
//  Created by Chrismanto Natanail Manik on 23/10/23.
//

import Foundation

struct MovieListResults: Codable{
    var page: Int
    var results: [Movie]
    var totalPages: Int
    var totalResults: Int
    
    private enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct Movie: Codable, Hashable{
    var adult: Bool
    var genreIds: [Int]
    let id: Int
    var title: String
    var originalLanguage: String
    var originalTitle: String
    var overview: String?
    var releaseDate: String
    var voteAverage: Double
    var posterPath: String?
    
    var imgURL: String{
        if let posterPath = posterPath, posterPath != ""{
            return "\(AppConfiguration().imagesBaseURL)\(posterPath)"

        }
        return ""
    }
    
    private enum CodingKeys: String, CodingKey {
        case adult, id, title, overview
        case genreIds = "genre_ids"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case posterPath = "poster_path"
    }}
