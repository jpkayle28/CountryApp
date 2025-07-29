//
//  CountriesServiceProtocol.swift
//  CountryApp
//
//  Created by Jean-Pierre Kayle on 29/07/2025.
//

protocol CountriesServiceProtocol {
    func fetchCountries() async throws -> [Country]
}
