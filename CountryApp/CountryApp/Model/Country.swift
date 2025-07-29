//
//  Country.swift
//  CountryApp
//
//  Created by Jean-Pierre Kayle on 29/07/2025.
//

import Foundation

struct Country: Codable, Identifiable, Equatable {
    
    var id = UUID()
    let name: String
    let capital: String?
    let currencies: [Currency]?
    
    private enum CodingKeys: String, CodingKey {
        case name, capital, currencies
    }
}

struct Currency: Codable, Equatable {
    
    let code: String?
    let name: String?
    let symbol: String?
    
}
