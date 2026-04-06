//
//  CountryModel.swift
//  Kibeti
//
//  Created by Dominic Bor  on 04/04/2026
//

import Foundation

struct Country: Codable, Identifiable {
    var id: UUID?
    let name: CountryName
    let idd: IDD
    let flags: Flags

    
    struct CountryName: Codable {
        let common: String
    }
    
    struct IDD: Codable {
        let root: String
        let suffixes: [String]
    }
    
    struct Flags: Codable {
        let png: String
    }

}


