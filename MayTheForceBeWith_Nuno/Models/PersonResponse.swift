//
//  PersonResponse.swift
//  MayTheForceBeWith_Nuno
//
//  Created by Nuno Pereira on 22/06/2019.
//  Copyright © 2019 nMfpCoding. All rights reserved.
//

import Foundation

struct PersonResponse: Decodable {
    var count: Int
    var next: String?
    var previous: String?
    var results: [Person]
    
    var hasNextPage: Bool {
        return next != nil
    }
    
    var hasPreviousPage: Bool {
        return previous != nil
    }
}
