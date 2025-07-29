//
//  APIManager.swift
//  CountryApp
//
//  Created by Jean-Pierre Kayle on 29/07/2025.
//

import Foundation

final class APIManager: CountriesServiceProtocol {
    
    static let shared = APIManager()
    
    private init() {}
    
    private let baseURL = "https://restcountries.com/v2/all?fields=name,capital,flag,population,currencies"
    
    func fetchCountries() async throws -> [Country] {
        guard let url = URL(string: baseURL) else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        try validate(response)
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .useDefaultKeys
        
        return try decoder.decode([Country].self, from: data)
    }
    
    private func validate(_ response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.cannotParseResponse)
        }
        
        switch httpResponse.statusCode {
            case 200..<300:
                return
            case 401:
                throw URLError(.userAuthenticationRequired)
            case 404:
                throw URLError(.fileDoesNotExist)
            default:
                throw URLError(.badServerResponse)
        }
    }
}
