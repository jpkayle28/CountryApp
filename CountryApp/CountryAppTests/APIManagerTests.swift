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
        let countries = try await mockService.fetchAllCountries()
        
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
            let countries = try await mockService.fetchAllCountries()
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
            let countries = try await service.fetchAllCountries()
            
            // Assert
            XCTAssertFalse(countries.isEmpty, "Expected non-empty countries array from live API")
            print("Fetched \(countries.count) countries from live API")
            print("First country: \(countries.first?.name ?? "N/A")")
        } catch {
            XCTFail("Live API call failed with error: \(error)")
        }
    }
    
    func testSearchCountriesByNameReturnsResults() async throws {
        // Given
        let manager = APIManager.shared
        let searchTerm = "France"
        
        // When
        let countries = try await manager.searchCountries(by: searchTerm)
        
        // Then
        XCTAssertFalse(countries.isEmpty, "Search should return at least one country for a valid name")
        XCTAssertTrue(countries.contains { $0.name.contains("France") }, "Result should contain 'France'")
    }
    
    func testSearchCountriesInvalidReturnsEmpty() async throws {
        // Given
        let manager = APIManager.shared
        let searchTerm = "InvalidCountryNameThatDoesNotExist"
        
        // When
        let countries = try await manager.searchCountries(by: searchTerm)
        
        // Then
        XCTAssertTrue(countries.isEmpty, "Search with invalid name should return empty array")
    }
}
