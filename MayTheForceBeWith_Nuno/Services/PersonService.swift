//
//  PersonService.swift
//  MayTheForceBeWith_Nuno
//
//  Created by Nuno Pereira on 21/06/2019.
//  Copyright © 2019 nMfpCoding. All rights reserved.
//

import Foundation

class PersonService: APIService {
    
    private static var _shared: PersonService?
    
    class var shared: PersonService {
        if _shared == nil {
            _shared = PersonService()
        }
        return _shared!
    }
    
    func getPersons(in page: Int, completion: @escaping (PersonResponse?, NetworkError?) -> ()) {
        fetchPersons(with: PersonRouter.page(page), completion: completion)
    }
    
    func searchPersons(by name: String, page: Int? = nil, completion: @escaping (PersonResponse?, NetworkError?) -> ()) {
        fetchPersons(with: PersonRouter.search(name, page), completion: completion)
    }
    
    private func fetchPersons (with router: NetworkRouter, completion: @escaping (PersonResponse?, NetworkError?) -> ()) {
        let request = router.request
        fetchData(with: request) { (response: NetworkResponse<PersonResponse>) in
            switch response {
            case .success(let response):
                completion(response, nil)
            case .error(let error):
                completion(nil, error as? NetworkError)
            }
        }
    }
}
