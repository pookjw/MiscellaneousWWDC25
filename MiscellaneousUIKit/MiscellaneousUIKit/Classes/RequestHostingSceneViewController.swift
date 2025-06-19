//
//  RequestHostingSceneViewController.swift
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/19/25.
//

import UIKit
import SwiftUI

final class RequestHostingSceneViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIButton(frame: view.bounds)
        button.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        var configuration = UIButton.Configuration.prominentGlass()
        configuration.title = "Menu"
        button.configuration = configuration
        button.showsMenuAsPrimaryAction = true
        button.menu = makeMenu()
        view.addSubview(button)
        
        view.backgroundColor = .systemBackground
    }
    
    private func makeMenu() -> UIMenu {
        let element = UIDeferredMenuElement.uncached { completion in
            var results: [UIMenuElement] = []
            
            do {
                let action = UIAction(title: "Request") { _ in
                    let request = UISceneSessionActivationRequest(hostingDelegateClass: HostingSceneDelegate.self)!
                    UIApplication.shared.activateSceneSession(for: request) { error in
                        fatalError()
                    }
                }
                
                results.append(action)
            }
            
            do {
                let action = UIAction(title: "Reqeust (Custom Text)") { _ in
                    let request = UISceneSessionActivationRequest(hostingDelegateClass: HostingSceneDelegate.self, id: "Custom Text", value: "From Swift!")!
                    UIApplication.shared.activateSceneSession(for: request) { error in
                        fatalError()
                    }
                }
                
                results.append(action)
            }
            
            completion(results)
        }
        
        return UIMenu(children: [element])
    }
}
