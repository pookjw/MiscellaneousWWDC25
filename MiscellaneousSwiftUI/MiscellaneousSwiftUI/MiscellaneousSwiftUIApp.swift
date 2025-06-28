//
//  MiscellaneousSwiftUIApp.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 6/26/25.
//

import SwiftUI

@main
struct MiscellaneousSwiftUIApp: App {
    init() {
        UserDefaults.standard.set(true, forKey: "com.apple.SwiftUI.IgnoreSolariumHardwareCheck")
        UserDefaults.standard.set(true, forKey: "com.apple.SwiftUI.IgnoreSolariumLinkedOnCheck")
    }
    
    var body: some Scene {
        WindowGroup {
            DemoListView()
        }
    }
}
