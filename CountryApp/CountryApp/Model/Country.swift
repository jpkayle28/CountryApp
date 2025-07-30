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
    let flag: String?
    
    private enum CodingKeys: String, CodingKey {
        case name, capital, currencies, flag
    }
}

struct Currency: Codable, Equatable {
    
    let code: String?
    let name: String?
    let symbol: String?
    
    var displayString: String {
        "\(name ?? "") (\(code ?? "")) \(symbol ?? "")"
    }
}
