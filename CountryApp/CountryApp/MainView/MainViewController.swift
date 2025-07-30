//
//  MainViewController.swift
//  CountryApp
//
//  Created by Jean-Pierre Kayle on 29/07/2025.
//

import UIKit
import SwiftUI

class MainViewController: BaseViewController<MainView> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Countries"
    }
    
    override func makeRootView() -> MainView {
        return MainView { [weak self] country in
            self?.goToDetail(country: country)
        }
    }
    
    func goToDetail(country: Country) {
        let detailViewController = DetailViewController()
        detailViewController.country = country
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
}
