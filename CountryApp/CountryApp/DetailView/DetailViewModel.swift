//
//  DetailViewModel.swift
//  CountryApp
//
//  Created by Jean-Pierre Kayle on 30/07/2025.
//

import Foundation
import SwiftUI

@MainActor
final class DetailViewModel: ObservableObject {
    
    @Published var flagImage: UIImage?
    @Published var isLoading = true
    @Published var loadError: Error?
    
    private let country: Country
    
    init(country: Country) {
        self.country = country
        Task {
            await loadFlag()
        }
    }
    
    var capital: String { country.capital ?? "" }
    var currencies: [Currency] { country.currencies ?? [] }
    
    private func loadFlag() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let image = try await APIManager.shared.downloadImage(for: country.flag)
            self.flagImage = image
        } catch {
            self.loadError = error
        }
    }
}
