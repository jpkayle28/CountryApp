//
//  DetailViewController.swift
//  CountryApp
//
//  Created by Jean-Pierre Kayle on 30/07/2025.
//

import UIKit
import SwiftUI

class DetailViewController: BaseViewController<DetailView> {
    
    var country: Country!
    
    
    override func makeRootView() -> DetailView {
        title = country.name
        return DetailView(country: country)
    }
}
