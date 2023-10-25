//
//  ParameterEncoding.swift
//  TestAssessmentMovie
//
//  Created by Chrismanto Natanail Manik on 23/10/23.
//

import Foundation

public typealias Parameters = [String: Any]
public typealias ErrorString = String
public protocol ParameterEncoder{
    func encode(urlRequest: inout URLRequest, with paramaters: Parameters) throws
}

public enum ParameterEncoding{
    case urlEncoding
    
    public func encode(urlRequest: inout URLRequest, urlParameters: Parameters?) throws {
        do {
            switch self {
            case .urlEncoding:
                guard let urlParameters = urlParameters else {return}
                try URLParameterEncoder().encode(urlRequest: &urlRequest, with: urlParameters)
            }
        } catch{
            throw error
        }
    }
}
