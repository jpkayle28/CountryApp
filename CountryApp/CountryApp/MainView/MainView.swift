//
//  MainView.swift
//  CountryApp
//
//  Created by Jean-Pierre Kayle on 29/07/2025.
//

import SwiftUI

struct MainView: View {
    
    var selectedCountry: ((Country) -> Void)?
    
    @StateObject private var viewModel = MainViewModel()
    @State private var searchText: String = ""
    
    var body: some View {
        ZStack {
            VStack(spacing: 16) {
                TextField("Search for a country...", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocorrectionDisabled(true)
                    .padding(.horizontal)
                    .onChange(of: searchText) { newValue in
                        viewModel.searchText = newValue
                    }
                
                List {
                    Section(header: Text("Selected Countries (\(viewModel.selectedCountries.count)/5)")) {
                        ForEach(viewModel.selectedCountries) { country in
                            Button {
                                viewModel.selectedCountry = country
                                selectedCountry?(country)
                            } label: {
                                HStack {
                                    Text(country.name)
                                    Spacer()
                                    if let capital = country.capital {
                                        Text(capital)
                                            .foregroundColor(.gray)
                                            .italic()
                                    }
                                }
                            }
                        }
                        .onDelete { indexSet in
                            for index in indexSet {
                                let country = viewModel.selectedCountries[index]
                                viewModel.removeCountry(country)
                            }
                        }
                    }
                    
                    if !viewModel.searchResults.isEmpty {
                        Section(header: Text("Search Results")) {
                            ForEach(viewModel.searchResults) { country in
                                Button {
                                    viewModel.addCountry(country)
                                } label: {
                                    VStack(alignment: .leading) {
                                        Text(country.name)
                                        if let currency = country.currencies?.first {
                                            Text("Currency: \(currency.name ?? "")")
                                                .font(.subheadline)
                                                .foregroundColor(.gray)
                                        }
                                    }
                                }

                            }
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())
            }
            
            if viewModel.isSearching {
                Color.black.opacity(0.2) // optional: dim background
                    .ignoresSafeArea()
                ProgressView("Searching...")
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .shadow(radius: 10)
            }
        }
        .alert(item: $viewModel.errorMessage) { err in
            Alert(title: Text("Error"), message: Text(err.message), dismissButton: .default(Text("OK")))
        }
    }
}
