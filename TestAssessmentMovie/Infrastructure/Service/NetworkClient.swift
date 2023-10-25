//
//  NetworkClient.swift
//  TestAssessmentMovie
//
//  Created by Chrismanto Natanail Manik on 22/10/23.
//

import Foundation

enum Results<String>{
    case success
    case failure(String)
}

protocol NetworkClient: AnyObject{
    associatedtype EndPoint: EndPointType
    func requestData<T: Codable>(_ endPoint: EndPoint, completion: @escaping (_ result: Result<T, NetworkError>) -> Void)
}


class NetworkSessionClient<EndPoint: EndPointType>: NetworkClient{
    private var task : URLSessionTask?
    private let session = URLSession(configuration: .default)
    func requestData<T>(_ endPoint: EndPoint, completion: @escaping (Result<T, NetworkError>) -> Void) where T : Decodable, T : Encodable {
        let session = URLSession.shared
        do{
            let request = try self.buildRequest(from: endPoint)
            task = session.dataTask(with: request, completionHandler: { data, response, error in
                if let _ = error{
                    completion(.failure(NetworkError.failed))
                    return
                }
                guard let response = response as? HTTPURLResponse else {return completion(.failure(NetworkError.invalidResponse))}
                                    let result = self.handleNetworkResponse(response)
                    switch result {
                    case .success:
                        guard let responseData = data else {
                            completion(.failure(NetworkError.noData))
                            return
                        }
                        if let jsonData = try? JSONDecoder().decode(T.self, from: responseData){
                            completion(.success(jsonData))
                        }else{
                           completion(.failure(.unableToDecode))
                        }
                    case .failure(let error):
                        guard let responseData = data else{
                            completion(.failure(NetworkError.noData))
                            return
                        }
                        if let jsonData = try? JSONDecoder().decode(MessageResponse.self, from: responseData){
                            print(jsonData)
                            completion(.failure(.generic(message: jsonData.message)))
                        }
                        completion(.failure(error))
                    }
            })
        }catch{
            completion(.failure(NetworkError.failed))
        }
        self.task?.resume()
    }
        
    fileprivate func buildRequest(from endPoint: EndPoint) throws -> URLRequest{
        var request = URLRequest(url: endPoint.baseUrl.appendingPathComponent(endPoint.path), cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0)
        request.httpMethod = endPoint.httpMethod.rawValue
        
        do{
            switch endPoint.task{
            case .request(addtionHeaders: let addtionHeaders):
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                addAdditionalHeaders(addtionHeaders, request: &request)
            case .requestParameters(encoding: let encoding, urlParameters: let urlParameters, addtionHeaders: let addtionHeaders):
                try self.configureParameters(encoding: encoding, urlParameters: urlParameters, request: &request)
                self.addAdditionalHeaders(addtionHeaders, request: &request)
            }
            return request
        } catch{
            throw error
        }
    }

    fileprivate func configureParameters(encoding: ParameterEncoding, urlParameters: Parameters?, request: inout URLRequest) throws{
        do{
            try encoding.encode(urlRequest: &request, urlParameters: urlParameters)
        }catch{
            throw error
        }
    }
    
    fileprivate func addAdditionalHeaders(_ headers: HttpHeaders?, request: inout URLRequest) {
        guard let headers = headers else {return}
        for (key,value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
    
    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> Results<NetworkError> {
        switch response.statusCode{
        case 200...299 :
            return .success
        case 401...500:
            return .failure(NetworkError.authenticationError)
        case 501...599 :
            return .failure(NetworkError.badRequest)
        case 600:
            return .failure(NetworkError.outdated)
        default:
            return .failure(NetworkError.failed)
        }
    }
}
