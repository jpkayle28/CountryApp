//
//  DetailView.swift
//  CountryApp
//
//  Created by Jean-Pierre Kayle on 30/07/2025.
//

import SwiftUI

struct DetailView: View {
    
    @StateObject private var viewModel: DetailViewModel
    
    init(country: Country) {
        _viewModel = StateObject(wrappedValue: DetailViewModel(country: country))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Group {
                if let image = viewModel.flagImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 250, height: 150)
                        .background(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(Color(.secondarySystemBackground))
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .shadow(radius: 5)
                } else if viewModel.isLoading {
                    ProgressView()
                        .frame(width: 250, height: 150)
                } else {
                    Image(systemName: "photo.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.gray)
                        .frame(width: 200)
                }
            }
            .frame(maxWidth: .infinity)
            
            HStack(alignment: .top) {
                
                Image(systemName: "building.2.crop.circle")
                    .foregroundColor(.blue)
                Text("Capital")
                    .font(.headline)
                 Spacer()
                    
                    Text(viewModel.capital.isEmpty ? "N/A" : viewModel.capital)
                        .font(.body)
            
            }
            
            HStack(alignment: .top) {
                Image(systemName: "coloncurrencysign.circle")
                    .foregroundColor(.green)
                VStack(alignment: .leading) {
                    Text("Currencies")
                        .font(.headline)
                    
                    if viewModel.currencies.isEmpty {
                        Text("N/A")
                    } else {
                        ForEach(viewModel.currencies, id: \.code) { currency in
                            Text(currency.displayString)
                        }
                    }
                }
            }
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    DetailView(country: Country(name: "France",
                                capital: "Paris",
                                currencies: [Currency(code: "EUR",
                                                      name: "Euro",
                                                      symbol: "€")],
                                flag: "https://flagcdn.com/w320/fr.png"))
}
