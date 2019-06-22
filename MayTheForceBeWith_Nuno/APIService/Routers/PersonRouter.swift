//
//  PersonRouter.swift
//  MayTheForceBeWith_Nuno
//
//  Created by Nuno Pereira on 21/06/2019.
//  Copyright © 2019 nMfpCoding. All rights reserved.
//

import Foundation

protocol NetworkRouter {
    var baseUrl: String { get }
    var path: String { get }
    var parameters: [URLQueryItem]? { get }
    var method: String { get }
    var request: URLRequest { get }
    var url: URL? { get }
}

extension NetworkRouter {
    var request: URLRequest {
        guard let url = url else { fatalError() }
        var request = URLRequest(url: url)
        request.httpMethod = method
        return request
    }
    
    var url: URL? {
        var urlComponents = URLComponents(string: baseUrl)
        urlComponents?.queryItems = parameters
        urlComponents?.path = path
        return urlComponents?.url
    }
}

enum PersonRouter: NetworkRouter {
    case all, page(Int), search(String, Int?)
    
    var baseUrl: String {
        return "https://swapi.co/"
    }
    
    var path: String {
        return "/api/people/"
    }
    
    var parameters: [URLQueryItem]? {
        switch self {
        case .all:
            return nil
        case .page(let page):
            return [
                URLQueryItem(name: "page", value: "\(page)")
            ]
        case .search(let name, let page):
            return [
                URLQueryItem(name: "search", value: name),
                URLQueryItem(name: "page", value: page == nil ? "" : "\(page!)")
            ]
        }
    }
    
    var method: String {
        return "GET"
    }
}
