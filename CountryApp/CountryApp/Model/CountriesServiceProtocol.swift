//
//  CountriesServiceProtocol.swift
//  CountryApp
//
//  Created by Jean-Pierre Kayle on 29/07/2025.
//

protocol CountriesServiceProtocol {
    
    func fetchAllCountries() async throws -> [Country]
    func searchCountries(by name: String) async throws -> [Country]
    
}
