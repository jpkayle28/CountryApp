//
//  APIManagerTests.swift
//  CountryAppTests
//
//  Created by Jean-Pierre Kayle on 29/07/2025.
//

import XCTest
@testable import CountryApp

class APIManagerTests: XCTestCase {
    
    func testFetchCountriesSuccess() async throws {
        // Arrange
        let mockService = MockCountriesService()
        let sampleCountry = Country(
            id: UUID(),
            name: "Lebanon",
            capital: "Beirut",
            currencies: [Currency(code: "LBP", name: "Lebanese pound", symbol: "ل.ل")]
        )
        mockService.resultToReturn = .success([sampleCountry])
        
        // Act
        let countries = try await mockService.fetchCountries()
        
        // Assert
        XCTAssertTrue(mockService.fetchCountriesCalled)
        XCTAssertEqual(countries.count, 1)
        XCTAssertEqual(countries.first?.name, "Lebanon")
    }
    
    func testFetchCountriesFailure() async {
        // Arrange
        let mockService = MockCountriesService()
        let sampleError = URLError(.badServerResponse)
        mockService.resultToReturn = .failure(sampleError)
        
        // Act & Assert
        do {
            let countries = try await mockService.fetchCountries()
            // If it somehow succeeds, print the unexpected result
            print("Unexpected countries: \(countries)")
            XCTFail("Expected failure, but succeeded.")
        } catch {
            // Expected path
            XCTAssertTrue(mockService.fetchCountriesCalled)
            XCTAssertEqual(error as? URLError, sampleError)
            print("Fetch failed as expected with error: \(error)")
        }
    }
    
    
    func testFetchCountriesLiveAPI() async throws {
        // Arrange
        let service = APIManager.shared
        
        // Act
        do {
            let countries = try await service.fetchCountries()
            
            // Assert
            XCTAssertFalse(countries.isEmpty, "Expected non-empty countries array from live API")
            print("Fetched \(countries.count) countries from live API")
            print("First country: \(countries.first?.name ?? "N/A")")
        } catch {
            XCTFail("Live API call failed with error: \(error)")
        }
    }
}
