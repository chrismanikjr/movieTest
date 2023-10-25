//
//  Video.swift
//  TestAssessmentMovie
//
//  Created by Chrismanto Natanail Manik on 24/10/23.
//

import Foundation

struct VideoResponse: Codable{
    var id: Int
    var results: [Video]
}

struct Video: Codable, Hashable{
    var name: String
    var type: String
    var site: String
    var key: String
    
    var videoUrl: String {
        return AppConfiguration().videoURL + key
    }
    var imgURL: String{
            return "\(AppConfiguration().imgVideoURL)\(key)/default.jpg"
    }
}
