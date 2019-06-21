//
//  APIService.swift
//  MayTheForceBeWith_Nuno
//
//  Created by Nuno Pereira on 21/06/2019.
//  Copyright © 2019 nMfpCoding. All rights reserved.
//

import Foundation

enum NetworkResponse<T> {
    case success(T)
    case error(Error)
}

enum NetworkError: Error {
    case badUrl
    case badResponse(Int?)
    case badData
    case badNetwork
    case errorParsing(String)
    
    var localizedDescription: String {
        switch self {
        case .badUrl:
            return "The url provided it is invalid or does not exist!"
        case .badNetwork:
            return ""
        case .badResponse(let statusCode):
            return "Something happened with the API: Status code: \(statusCode ?? 0)"
        case .badData:
            return "Something happened getting the returned data!"
        case .errorParsing(let description):
            return "Trying to parse the response but this error happened: " + description
        }
    }
}

protocol APIService {
    var session: URLSession { get }
    
    func fetchData<T: Decodable>(with request: URLRequest, completion: @escaping (NetworkResponse<T>) -> ())
}


extension APIService {
    var session: URLSession {
        return URLSession.shared
    }
    
    func fetchData<T: Decodable>(with request: URLRequest, completion: @escaping (NetworkResponse<T>) -> ()) {
        guard let requestUrl = request.url else {
            completion(.error(NetworkError.badUrl))
            return
        }
        
        session.dataTask(with: requestUrl) { (data, resp, err) in
            guard err == nil else {
                completion(.error(err!))
                return
            }
            
            guard let response = resp as? HTTPURLResponse, (200...299) ~= response.statusCode else {
                completion(.error(NetworkError.badResponse((resp as? HTTPURLResponse)?.statusCode)))
                return
            }
            
            guard let parsedData = data else {
                completion(.error(NetworkError.badData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                let value = try decoder.decode(T.self, from: parsedData)
                completion(.success(value))
            } catch let error {
                completion(.error(NetworkError.errorParsing((error as? DecodingError).debugDescription)))
            }
            
            }.resume()
    }
}
