//
//  NetworkError.swift
//  TestAssessmentMovie
//
//  Created by Chrismanto Natanail Manik on 22/10/23.
//

import Foundation
public enum NetworkError: Error{
    case authenticationError
    case badRequest
    case outdated
    case failed
    case noData
    case generic(message: String)
    case unableToDecode
    case invalidResponse
    case parametersNil
    case encodingFailed
    case missingURL
    
    var descriptionString: String?{
        switch self {
        case .authenticationError:
            return "Token Expired or Token Invalid"
        case .badRequest:
            return "Bad Request"
        case .outdated:
            return "Out Dated"
        case .failed:
            return "Failed"
        case .noData:
            return "Return Data nil"
        case .generic(let message):
            return message
        case .unableToDecode:
            return "The server returned data in an unexpected format. Try updating the  the app."
        case .invalidResponse:
            return "Invalid response"
        case .parametersNil:
            return "Parameters were nil"
        case .encodingFailed:
            return "Parameters Encoding failed"
        case .missingURL:
            return "URL is nil"
        }
    }
}
