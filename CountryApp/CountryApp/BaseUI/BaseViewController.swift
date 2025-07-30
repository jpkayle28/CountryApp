//
//  BaseViewController.swift
//  CountryApp
//
//  Created by Jean-Pierre Kayle on 29/07/2025.
//

import UIKit
import SwiftUI

class BaseViewController<Content: View>: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHostingController()
    }
    
    /// Subclasses override this to provide the SwiftUI view
    func makeRootView() -> Content {
        fatalError("Subclasses must override makeRootView()")
    }
    
    private func setupHostingController() {
        let rootView = makeRootView()
        let hostingController = UIHostingController(rootView: rootView)
        addChild(hostingController)
        
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hostingController.view)
        
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        hostingController.didMove(toParent: self)
    }
    
}
