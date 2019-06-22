//
//  Person.swift
//  MayTheForceBeWith_Nuno
//
//  Created by Nuno Pereira on 21/06/2019.
//  Copyright © 2019 nMfpCoding. All rights reserved.
//

import Foundation

struct Person: Decodable {
    var name: String
    var height: String
    var mass: String
    var hairColor: String
    var skinColor: String
    var eyeColor: String
    var birthYear: String
    var gender: String
    var homeworld: String
    var films: [String]
    var species: [String]
    var vehicles: [String]
    var starships: [String]
    var created: Date = Date()
    var edited: Date = Date()
    var url: String
    
    private enum CodingKeys: String, CodingKey {
        case name
        case height
        case mass
        case hairColor
        case skinColor
        case eyeColor
        case birthYear
        case gender
        case homeworld
        case films
        case species
        case vehicles
        case starships
        case created
        case edited
        case url
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        var dateFormatter: DateFormatter?
        
        name = try container.decode(String.self, forKey: .name)
        height = try container.decode(String.self, forKey: .height)
        mass = try container.decode(String.self, forKey: .mass)
        hairColor = try container.decode(String.self, forKey: .hairColor)
        skinColor = try container.decode(String.self, forKey: .skinColor)
        eyeColor = try container.decode(String.self, forKey: .eyeColor)
        birthYear = try container.decode(String.self, forKey: .birthYear)
        gender = try container.decode(String.self, forKey: .gender)
        homeworld = try container.decode(String.self, forKey: .homeworld)
        films = try container.decode([String].self, forKey: .films)
        species = try container.decode([String].self, forKey: .species)
        vehicles = try container.decode([String].self, forKey: .vehicles)
        starships = try container.decode([String].self, forKey: .starships)
        
        if let createdDateString = try? container.decode(String.self, forKey: .created) {
            dateFormatter = DateFormatter()
            dateFormatter?.dateFormat = "HH:mm dd/mm/yyyy"
            created = dateFormatter?.date(from: createdDateString) ?? Date()
        }
        
        if let editedDateString = try? container.decode(String.self, forKey: .edited) {
            if dateFormatter == nil {
                dateFormatter = DateFormatter()
                dateFormatter?.dateFormat = "HH:mm dd/mm/yyyy"
            }
            edited = dateFormatter?.date(from: editedDateString) ?? Date()
        }
        url = try container.decode(String.self, forKey: .url)
    }
}

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
