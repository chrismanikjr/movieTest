//
//  AppConfiguration.swift
//  TestAssessmentMovie
//
//  Created by Chrismanto Natanail Manik on 22/10/23.
//

import Foundation

final class AppConfiguration {
    lazy var apiToken: String = {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "ApiToken") as? String else {
            fatalError("ApiToken must not be empty in plist")
        }
        return apiKey
    }()
    lazy var apiBaseURL: String = {
        guard let apiBaseURL = Bundle.main.object(forInfoDictionaryKey: "ApiBaseURL") as? String else {
            fatalError("ApiBaseURL must not be empty in plist")
        }
        
        return apiBaseURL
    }()
    lazy var imagesBaseURL: String = {
        guard let imageBaseURL = Bundle.main.object(forInfoDictionaryKey: "ImageBaseURL") as? String else {
            fatalError("ImageBaseURL must not be empty in plist")
        }
        return imageBaseURL
    }()
    
    lazy var videoURL: String = {
        guard let videoURL = Bundle.main.object(forInfoDictionaryKey: "VideoURL") as? String else {
            fatalError("VideoURL must not be empty in plist")
        }
        return videoURL
    }()
    
    lazy var imgVideoURL: String = {
        guard let imgVideoURL = Bundle.main.object(forInfoDictionaryKey: "ImageVideoURL") as? String else {
            fatalError("ImageVideoURL must not be empty in plist")
        }
        return imgVideoURL
    }()
}
