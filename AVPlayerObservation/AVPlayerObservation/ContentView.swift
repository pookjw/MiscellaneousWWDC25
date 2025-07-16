//
//  ContentView.swift
//  AVPlayerObservation
//
//  Created by Jinwoo Kim on 7/16/25.
//

import SwiftUI
import AVFoundation
import AVKit

struct ContentView: View {
    @State private var viewModel = ViewModel()
    
    var body: some View {
        VStack {
            VideoPlayer(player: viewModel.player)
            Text(String(describing: viewModel.player.currentItem?.currentTime().seconds ?? 0))
        }
    }
}

@Observable
final class ViewModel {
    var player: AVQueuePlayer = .init(url: Bundle.main.url(forResource: "video", withExtension: "mp4")!)
    private let looper: AVPlayerLooper
    
    init() {
        let player: AVQueuePlayer = .init(url: Bundle.main.url(forResource: "video", withExtension: "mp4")!)
        self.player = player
        looper = .init(player: player, templateItem: player.currentItem!)
        player.play()
    }
}

#Preview {
    ContentView()
}
