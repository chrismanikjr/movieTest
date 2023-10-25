//
//  GenreResponse.swift
//  TestAssessmentMovie
//
//  Created by Chrismanto Natanail Manik on 23/10/23.
//

import Foundation

struct GenreResults: Codable{
    var genres: [Genre]
}

struct Genre: Codable, Hashable{
    var id: Int
    var name: String
}
