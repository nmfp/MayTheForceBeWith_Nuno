//
//  Person.swift
//  MayTheForceBeWith_Nuno
//
//  Created by Nuno Pereira on 21/06/2019.
//  Copyright © 2019 nMfpCoding. All rights reserved.
//

import Foundation

struct Person: Codable {
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
    var isFavourite: Bool = false
    
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
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(name, forKey: .name)
        try container.encode(height, forKey: .height)
        try container.encode(mass, forKey: .mass)
        try container.encode(hairColor, forKey: .hairColor)
        try container.encode(skinColor, forKey: .skinColor)
        try container.encode(eyeColor, forKey: .eyeColor)
        try container.encode(birthYear, forKey: .birthYear)
        try container.encode(gender, forKey: .gender)
        try container.encode(homeworld, forKey: .homeworld)
        try container.encode(films, forKey: .films)
        try container.encode(species, forKey: .species)
        try container.encode(vehicles, forKey: .vehicles)
        try container.encode(starships, forKey: .starships)
        
        var dateFormatter: DateFormatter?
        dateFormatter = DateFormatter()
        dateFormatter?.dateFormat = "HH:mm dd/mm/yyyy"
        
        if let createdString = dateFormatter?.string(from: created) {
            try container.encode(createdString, forKey: .created)
        }
        
        if let editedString = dateFormatter?.string(from: edited) {
            try container.encode(editedString, forKey: .edited)
        }
        
        try container.encode(url, forKey: .url)
    }
    
    mutating func setAsFavourite() {
        isFavourite = !isFavourite
    }
}

//For tests purpose
extension Person {
    init(name: String) {
        self.name = name
        self.height = ""
        self.mass = ""
        self.hairColor = ""
        self.skinColor = ""
        self.eyeColor = ""
        self.birthYear = ""
        self.gender = ""
        self.homeworld = ""
        self.films = []
        self.species = []
        self.vehicles = []
        self.starships = []
        self.created = Date()
        self.edited = Date()
        self.url = ""
        self.isFavourite = false
    }
}
