//
//  MayTheForceBeWith_NunoTests.swift
//  MayTheForceBeWith_NunoTests
//
//  Created by Nuno Pereira on 21/06/2019.
//  Copyright © 2019 nMfpCoding. All rights reserved.
//

import XCTest
@testable import MayTheForceBeWith_Nuno

class MayTheForceBeWith_NunoTests: XCTestCase {

    override func setUp() {
        
    }

    func testCreatingUrlGetRequest() {
        let page: Int = 2
        let request = PersonRouter.page(page)
        
        XCTAssertEqual(request.url?.scheme, "https")
        XCTAssertEqual(request.url?.host, "swapi.co")
        XCTAssertEqual(request.url?.query, "page=\(page)")
    }
    
    func testParseFavouriteResponse() throws {
        let jsonString = "{\"success\":true}"
        let jsonData = jsonString.data(using: .utf8)
        
        let response = try JSONDecoder().decode(FavouriteResponse.self, from: jsonData!)
        
        XCTAssertEqual(response.success, true)
    }
    
    func testSettingAsFavourite() {
        var personToBeFavourite = Person(name: "R2")
        personToBeFavourite.setAsFavourite()
        XCTAssertEqual(personToBeFavourite.isFavourite, true)
    }
}
