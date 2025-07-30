//
//  APIManager.swift
//  CountryApp
//
//  Created by Jean-Pierre Kayle on 29/07/2025.
//

import UIKit

final class APIManager: CountriesServiceProtocol {
    
    static let shared = APIManager()
    
    private init() {}
    
    func fetchAllCountries() async throws -> [Country] {
        let baseURL = "https://restcountries.com/v2/all?fields=name,capital,flag,population,currencies"

        guard let url = URL(string: baseURL) else {
            throw URLError(.badURL)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        try validate(response)
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .useDefaultKeys
        
        return try decoder.decode([Country].self, from: data)
    }
    
    func searchCountries(by name: String) async throws -> [Country] {
        let encodedName = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? name
        let urlString = "https://restcountries.com/v2/name/\(encodedName)?fields=name,capital,flag,population,currencies"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            try validate(response)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .useDefaultKeys
            return try decoder.decode([Country].self, from: data)
        } catch APIError.notFound {
            return []
        }
    }
    
    private func validate(_ response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        switch httpResponse.statusCode {
            case 200..<300:
                return
            case 401:
                throw APIError.unauthorized
            case 404:
                throw APIError.notFound
            default:
                throw APIError.serverError
        }
    }
    
    func downloadImage(for urlString: String?) async throws -> UIImage {
        guard let url = URL(string: urlString ?? "") else {
            throw APIError.notFound
        }
        do {
            let (data, response) = try await URLSession.shared.data(from: url, delegate: nil)
            try validate(response)
            guard let image = SVGHelper.default.imageFromSVGData(data) else {
                throw APIError.invalidImage
            }
            return image
        } catch let error {
            throw error
        }
    }
}
