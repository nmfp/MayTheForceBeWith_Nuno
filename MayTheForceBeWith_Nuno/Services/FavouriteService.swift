//
//  FavouriteService.swift
//  MayTheForceBeWith_Nuno
//
//  Created by Nuno Pereira on 22/06/2019.
//  Copyright © 2019 nMfpCoding. All rights reserved.
//

import Foundation

class FavouriteService: APIService {
    
    private static var _shared: FavouriteService?
    
    class var shared: FavouriteService {
        if _shared == nil {
            _shared = FavouriteService()
        }
        return _shared!
    }
    
    func saveFavourite(person: Person, completion: @escaping (FavouriteResponse?, NetworkError?) -> ()) {
        fetchPersons(with: FavouriteRouter.favourite(person), completion: completion)
    }
    
    private func fetchPersons (with router: NetworkRouter, completion: @escaping (FavouriteResponse?, NetworkError?) -> ()) {
        let request = router.request
        fetchData(with: request) { (response: NetworkResponse<FavouriteResponse>) in
            switch response {
            case .success(let response):
                completion(response, nil)
            case .error(let error):
                completion(nil, error as? NetworkError)
            }
        }
    }
}
