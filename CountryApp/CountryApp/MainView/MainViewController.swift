//
//  MainViewController.swift
//  CountryApp
//
//  Created by Jean-Pierre Kayle on 29/07/2025.
//

import UIKit
import SwiftUI

class MainViewController: BaseViewController<MainView> {
    
    init() {
        let mainView = MainView { country in
            print(country.name)
        }
        super.init(rootView: mainView)
        title = "Countries"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
