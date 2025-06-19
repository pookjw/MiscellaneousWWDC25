//
//  HostingSceneDelegate.swift
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/19/25.
//

import UIKit
import SwiftUI
import SwiftUIPrivate

final class HostingSceneDelegate: UIResponder, @MainActor UIHostingSceneDelegate {
    @objc class func activationRequest() -> __UISceneSessionActivationRequest {
        let _impl = Mirror(reflecting: UISceneSessionActivationRequest(hostingDelegateClass: HostingSceneDelegate.self)!).descendant("_impl")!
        let wrapper = Mirror(reflecting: _impl).descendant("wrapper")!
        let impl = Mirror(reflecting: wrapper).descendant("impl") as! __UISceneSessionActivationRequest
        return impl
    }
    
    static var rootScene: some Scene {
        WindowGroup {
            Text("Hello World!")
        }
        
        WindowGroup(id: "Custom Text", for: String.self) { text in
            Text(text.wrappedValue ?? "(nil)")
        }
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
    }
}
