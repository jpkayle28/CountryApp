//
//  BaseViewController.swift
//  CountryApp
//
//  Created by Jean-Pierre Kayle on 29/07/2025.
//

import UIKit
import SwiftUI

class BaseViewController<Content: View>: UIViewController {
    
    private let rootView: Content
    
    init(rootView: Content) {
        self.rootView = rootView
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHostingController()
    }
    
    private func setupHostingController() {
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
