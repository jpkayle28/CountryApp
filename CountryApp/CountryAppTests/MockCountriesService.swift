//
//  MockCountriesService.swift
//  CountryAppTests
//
//  Created by Jean-Pierre Kayle on 29/07/2025.
//

import Foundation
@testable import CountryApp

final class MockCountriesService: CountriesServiceProtocol {
    
    var fetchCountriesCalled = false
    var resultToReturn: Result<[Country], Error>!
    
    func fetchCountries() async throws -> [Country] {
        fetchCountriesCalled = true
        switch resultToReturn {
            case .success(let countries):
                return countries
            case .failure(let error):
                throw error
            case .none:
                return []
        }
    }
}
