//
//  HostingSceneRepresentationDemoViewController.swift
//  MiscellaneousAppKit
//
//  Created by Jinwoo Kim on 6/26/25.
//

import Cocoa
import SwiftUI

final class HostingSceneRepresentationDemoViewController: NSViewController {
    private static let demoScene = NSHostingSceneRepresentation { 
        WindowGroup(id: "Hello", for: String.self) { value in 
            Text(value.wrappedValue ?? "(nil)")
        }
    }
    
    @objc class func registerHostingScene() {
        NSApplication.shared.addSceneRepresentation(HostingSceneRepresentationDemoViewController.demoScene)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = NSButton(title: "Open", target: self, action: #selector(buttonDidTrigger(_:)))
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
    @objc private func buttonDidTrigger(_ sender: NSButton) {
        HostingSceneRepresentationDemoViewController.demoScene.environment.openWindow(id: "Hello", value: "Yay!")
    }
}
