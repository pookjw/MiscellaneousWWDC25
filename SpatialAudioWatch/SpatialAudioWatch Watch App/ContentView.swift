//
//  ContentView.swift
//  SpatialAudioWatch Watch App
//
//  Created by Jinwoo Kim on 7/13/25.
//

import SwiftUI
import AVKit
import AVFoundation
import CoreAudio

struct ContentView: View {
    @State private var playerItem = AVPlayerItem(url: Bundle.main.url(forResource: "IMG_8803", withExtension: "MOV")!)
    @State private var player = AVPlayer()
    
    @State private var assetTrack: AVAssetTrack?
    @State private var metadataBlob: Data?
    @State private var selectedRenderingStyle = 7
    @State private var effectIntensity: Float32 = 1.0
    
    var body: some View {
        List {
            Section {
                VideoPlayer(player: player)
                    .frame(height: 150)
            }
            
            Section {
                ForEach(0..<10) { style in
                    Button { 
                        selectedRenderingStyle = style
                    } label: { 
                        Label { 
                            Text(style.spatialAudioRenderingStyleString ?? "(unknown)")
                        } icon: { 
                            if selectedRenderingStyle == style {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            }
            
            Section {
                Slider(value: $effectIntensity, in: 0.1...1.0)
            }
        }
        .task {
            player.replaceCurrentItem(with: playerItem)
            
            let audioTracks = try! await playerItem.asset.loadTracks(withMediaType: .audio)
            for track in audioTracks {
                let descriptions = try! await track.load(.formatDescriptions)
                guard let description = descriptions.first else { continue }
                guard description.mediaType == .audio && description.mediaSubType.rawValue == kAudioFormatAPAC else { continue }
                assetTrack = track
                break
            }
            
            for track in try! await playerItem.asset.loadTracks(withMediaType: .metadata) {
                guard let metadataBlob = saw_metadataBlob(track) else {
                    continue
                }
                self.metadataBlob = metadataBlob
                break
            }
            
            await didChangeEffect()
            
            for await _ in NotificationCenter.default.notifications(named: AVPlayerItem.didPlayToEndTimeNotification, object: playerItem) {
                await playerItem.seek(to: .zero, toleranceBefore: .zero, toleranceAfter: .zero)
                player.play()
            }
        }
        .task(id: effectIntensity) {
            guard assetTrack != nil else { return }
            await didChangeEffect()
        }
        .task(id: selectedRenderingStyle) {
            guard assetTrack != nil else { return }
            await didChangeEffect()
        }
    }
    
    private func didChangeEffect() async  {
        let tracks = try! await playerItem.asset.loadTracks(withMediaType: .audio)
        var assetTrack: AVAssetTrack?
        for track in tracks {
            let descriptions = try! await track.load(.formatDescriptions)
            guard let description = descriptions.first else { continue }
            guard description.mediaType == .audio && description.mediaSubType.rawValue == kAudioFormatAPAC else { continue }
            assetTrack = track
            break
        } 
        playerItem.audioMix = saw_audioMix(assetTrack!, metadataBlob!, selectedRenderingStyle, effectIntensity)
    }
}

#Preview {
    ContentView()
}

extension Int {
    fileprivate var spatialAudioRenderingStyleString: String? {
        switch self {
        case 0: return "Cinematic"
        case 1: return "Studio"
        case 2: return "In Frame"
        case 3: return "Cinematic Background Stem"
        case 4: return "Cinematic Foreground Stem"
        case 5: return "Studio Foreground Stem"
        case 6: return "In Frame Foreground Stem"
        case 7: return "Standard"
        case 8: return "Studio Background Stem"
        case 9: return "In Frame Background Stem"
        default: return nil
        }
    }
}
