//
//  FavouriteRouter.swift
//  MayTheForceBeWith_Nuno
//
//  Created by Nuno Pereira on 22/06/2019.
//  Copyright © 2019 nMfpCoding. All rights reserved.
//

import Foundation

enum FavouriteRouter: NetworkRouter {
    case favourite(Person)
    
    var baseUrl: String {
        return "http://webhook.site/"
    }
    
    var path: String {
        return "/06b0460d-01b5-4b15-92dd-e97b0d3d5379"
    }
    
    var parameters: [URLQueryItem]? {
        return nil
    }
    
    var method: String {
        return "POST"
    }
    
    var body: Data? {
        switch self {
        case .favourite(let person):
            return try? JSONEncoder().encode(person)
        }
    }
}
