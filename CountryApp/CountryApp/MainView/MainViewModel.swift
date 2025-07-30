//
//  MainViewModel.swift
//  CountryApp
//
//  Created by Jean-Pierre Kayle on 29/07/2025.
//

import Foundation
import Combine
import CoreLocation

@MainActor
final class MainViewModel: NSObject, ObservableObject {
    
    // MARK: - Published Properties
    
    @Published var searchText = ""
    @Published var searchResults: [Country] = []
    @Published var selectedCountries: [Country] = []
    @Published var selectedCountry: Country?
    @Published var isSearching: Bool = true
    @Published var errorMessage: IdentifiableError?
    
    // MARK: - Private
    
    private let locationManager = CLLocationManager()
    private var cancellables = Set<AnyCancellable>()
    
    private let defaultCountryName = "Lebanon"
    private var hasLoadedLocationCountry = false

    
    // MARK: - Init
    
    override init() {
        super.init()
        observeSearchText()
        setupLocation()
    }
    
    // MARK: - Location Handling
    
    private func setupLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    private func loadDefaultCountry() async {
        do {
            let countries = try await APIManager.shared.searchCountries(by: defaultCountryName)
            if let first = countries.first {
                addCountry(first)
            }
        } catch {
            await MainActor.run {
                self.errorMessage = IdentifiableError(message: "Failed to load default country: \(error.localizedDescription)")
            }
        }
    }
    
    private func loadCountryFor(location countryName: String) async {
        do {
            let countries = try await APIManager.shared.searchCountries(by: countryName)
            if let first = countries.first {
                addCountry(first)
            }
        } catch {
            print("Failed to load country by location: \(error)")
            await MainActor.run {
                self.errorMessage = IdentifiableError(message: "Failed to load country from location: \(error.localizedDescription)")
            }
            await loadDefaultCountry()
        }
    }
    
    // MARK: - Country Management
    
    func addCountry(_ country: Country) {
        guard selectedCountries.count < 5 else { return }
        guard !selectedCountries.contains(country) else { return }
        selectedCountries.append(country)
    }
    
    func removeCountry(_ country: Country) {
        selectedCountries.removeAll { $0 == country }
    }
    
    // MARK: - Search
    
    private func observeSearchText() {
        $searchText
            .debounce(for: .seconds(0.8), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] term in
                Task {
                    await self?.performSearch(term: term)
                }
            }
            .store(in: &cancellables)
    }
    
    private func performSearch(term: String) async {
        guard !term.isEmpty else {
            await MainActor.run {
                self.searchResults = []
                self.isSearching = false
                self.errorMessage = nil
            }
            return
        }
        
        await MainActor.run {
            self.isSearching = true
            self.errorMessage = nil
        }
        
        do {
            let results = try await APIManager.shared.searchCountries(by: term)
            let filtered = results.filter { !self.selectedCountries.contains($0) }
            
            await MainActor.run {
                self.searchResults = filtered
                self.isSearching = false
                
                if filtered.isEmpty {
                    self.errorMessage = IdentifiableError(message: "No results found for \"\(term)\".")
                }
            }
        } catch {
            await MainActor.run {
                self.searchResults = []
                self.isSearching = false
                self.errorMessage = IdentifiableError(message: "Search failed: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension MainViewModel: CLLocationManagerDelegate {
    
    nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
            case .authorizedWhenInUse, .authorizedAlways:
                manager.requestLocation()
            case .denied, .restricted:
                Task {
                    await loadDefaultCountry()
                }
            default:
                break
        }
    }
    
    nonisolated func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        Task {
            let geocoder = CLGeocoder()
            
            do {
                let placemarks = try await geocoder.reverseGeocodeLocation(location)
                if let countryName = placemarks.first?.country {
                    await MainActor.run {
                        // Ensure only one execution
                        if !self.hasLoadedLocationCountry {
                            self.hasLoadedLocationCountry = true
                            Task {
                                await self.loadCountryFor(location: countryName)
                            }
                        }
                    }
                } else {
                    await self.loadDefaultCountry()
                }
            } catch {
                print("Geocoding error: \(error)")
                await self.loadDefaultCountry()
            }
        }
    }
    
    nonisolated func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error)")
        Task {
            await loadDefaultCountry()
        }
    }
}
