//
//  CALayerDemoView.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 6/29/25.
//

#if !os(watchOS)

import SwiftUI
import AVFoundation

struct CALayerDemoView: View {
    @State private var player = AVPlayer(url: Bundle.main.url(forResource: "0", withExtension: "mp4")!)
    
    var body: some View {
        _CALayerView(type: AVPlayerLayer.self) { layer in
            layer.player = player
        }
        .onAppear {
            player.play()
        }
    }
}

#Preview {
    CALayerDemoView()
}

#endif
