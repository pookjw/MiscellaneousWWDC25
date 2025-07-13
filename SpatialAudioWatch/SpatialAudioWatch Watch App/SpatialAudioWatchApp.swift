//
//  SpatialAudioWatchApp.swift
//  SpatialAudioWatch Watch App
//
//  Created by Jinwoo Kim on 7/13/25.
//

import SwiftUI

@main
struct SpatialAudioWatch_Watch_AppApp: App {
    init() {
        assert(saw_isAudioMixSupported());
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
