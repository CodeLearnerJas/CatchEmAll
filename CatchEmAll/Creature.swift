//
//  Creature.swift
//  CatchEmAll
//
//  Created by GuitarLearnerJas on 25/9/2024.
//

import Foundation

struct Creature: Codable, Identifiable {
    let id = UUID().uuidString
    var name: String
    var url: String // url for detail on Pokemon
    
    //for removing id when coding
    enum CodingKeys: CodingKey {
        case name
        case url
    }
}
