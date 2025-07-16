//
//  AVPlayerObservationApp.swift
//  AVPlayerObservation
//
//  Created by Jinwoo Kim on 7/16/25.
//

import SwiftUI
import AVFoundation

@main
struct AVPlayerObservationApp: App {
    init() {
        AVPlayer.isObservationEnabled = true
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
