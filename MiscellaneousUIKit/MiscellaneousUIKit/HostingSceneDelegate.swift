//
//  HostingSceneDelegate.swift
//  MiscellaneousUIKit
//
//  Created by Jinwoo Kim on 6/19/25.
//

import UIKit
import SwiftUI

final class HostingSceneDelegate: UIResponder, @MainActor UIHostingSceneDelegate {
    static var rootScene: some Scene {
        WindowGroup {
            Text("Hello World!")
        }
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        print(session.role)
        print(session.configuration)
        print(session.userInfo)
        connectionOptions.userActivities.forEach { a in
            print(a.activityType, a.userInfo)
        }
    }
}
