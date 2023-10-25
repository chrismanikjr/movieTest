//
//  MovieDetail.swift
//  TestAssessmentMovie
//
//  Created by Chrismanto Natanail Manik on 24/10/23.
//

import Foundation

struct MovieDetail: Codable, Hashable{
    let id: Int
    let title: String
    let posterPath: String?
    let voteAverage: Double
    let status: String
    let overview: String
    let releaseDate: String
    let genres: [Genre]
    let runtime: Int
    
    var imgURL: String{
        if let posterPath = posterPath{
            return "\(AppConfiguration().imagesBaseURL)\(posterPath)"

        }
        return ""
    }
    var rating: String{
        return String(format: "%.1f", voteAverage)
    }
    var genresString: String{
        var genreValue = ""
        for (index, genre) in genres.enumerated() {
            genreValue += "\(genre.name) \(index == genres.count - 1 ? "" : ",")"
        }
        return genreValue
    }
    
    private enum CodingKeys: String, CodingKey{
        case id, title,status, overview, genres, runtime
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case releaseDate = "release_date"
    }
}
