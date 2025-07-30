//
//  IdentifiableError.swift
//  CountryApp
//
//  Created by Jean-Pierre Kayle on 29/07/2025.
//

import Foundation

struct IdentifiableError: Identifiable {
    
    let id = UUID()
    let message: String
    
}
