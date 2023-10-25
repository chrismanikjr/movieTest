//
//  ndPointType.swift
//  TestAssessmentMovie
//
//  Created by Chrismanto Natanail Manik on 22/10/23.
//

import Foundation

protocol EndPointType{
    var baseUrl: URL {get}
    var path: String {get}
    var httpMethod: HttpMethodType {get}
    var task: HttpTask {get}
    var headers: HttpHeaders? {get}
}

enum HttpMethodType: String{
    case get    = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
}

public typealias HttpHeaders = [String:String]


public enum HttpTask {
    case request(addtionHeaders: HttpHeaders?)
    case requestParameters(encoding: ParameterEncoding, urlParameters: Parameters?, addtionHeaders: HttpHeaders?)

}
