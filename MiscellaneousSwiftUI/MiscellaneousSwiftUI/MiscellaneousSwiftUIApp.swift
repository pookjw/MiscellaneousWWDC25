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
#if os(macOS) || os(visionOS)
        .defaultLaunchBehavior(.presented) // 기본으로 어떤 Scene이 뜰지 정할 수 있음
#endif
#if os(visionOS)
        .restorationBehavior(.disabled)
#endif
#if !os(watchOS)
        .commands {
            TextEditingCommands()
        }
#endif
        
        AssistiveAccess { 
            VStack {
                Text("AssistiveAccess Scene")
                DemoListView()
            }
        }
    }
}
