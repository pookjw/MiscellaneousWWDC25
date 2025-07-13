//
//  ContentView.swift
//  MyApp
//
//  Created by Jinwoo Kim on 7/12/25.
//

import SwiftUI
import AVKit
import PhotosUI
import Cinematic
import CoreAudio

struct ContentView: View {
    @State private var selectedPickerItem: PhotosPickerItem?
    @State private var playerItem: AVPlayerItem?
    @State private var player = AVPlayer()
    
    @State private var spatialAudioInfo: CNAssetSpatialAudioInfo?
    @State private var spatialAudioRenderingStyle: CNSpatialAudioRenderingStyle = .cinematic
    
    @State private var effectIntensity: Float32 = 1.0
    
    var body: some View {
        VStack {
            VideoPlayer(player: player)
            
            if spatialAudioInfo != nil {
                Menu("Spatial Audio Info") { 
                    let allRenderingStyles: [CNSpatialAudioRenderingStyle] = (0..<10).compactMap { CNSpatialAudioRenderingStyle(rawValue: $0) }
                    
                    Picker("", selection: $spatialAudioRenderingStyle) { 
                        ForEach(allRenderingStyles, id: \.self) { style in
                            Text(style.spatialAudioRenderingStyleString ?? "(unknown)")
                                .tag(style)
                        }
                    }
                }
                
                Slider(value: $effectIntensity, in: 0.1...1.0)
            }
            
            PhotosPicker(selection: $selectedPickerItem,
                         matching: unsafeBitCast(__PHPickerFilter.cinematicVideos, to: PHPickerFilter.self),
                         photoLibrary: .shared()) {
                Label("Choose Asset", systemImage: "video")
            }
        }
        .padding()
        .task(id: selectedPickerItem) {
            guard let itemIdentifier = selectedPickerItem?.itemIdentifier else {
                return
            }
            
            let asset = PHAsset.fetchAssets(withLocalIdentifiers: [itemIdentifier], options: nil).firstObject!
            
            let videoRequestOptions = PHVideoRequestOptions()
            videoRequestOptions.version = .original
            videoRequestOptions.deliveryMode = .highQualityFormat
            videoRequestOptions.isNetworkAccessAllowed = true
            
            let avAsset = await withCheckedContinuation { continuation in
                PHImageManager.default().requestAVAsset(forVideo: asset, options: videoRequestOptions) { avAsset, _, _ in
                    continuation.resume(returning: avAsset)
                }
            }!
            
            let cnAssetInfo = try! await CNAssetInfo(asset: avAsset)
            let composition = AVMutableComposition()
            
            let compositionInfo: CNCompositionInfo = composition.addTracks(for: cnAssetInfo, preferredStartingTrackID: kCMPersistentTrackID_Invalid)
            try! compositionInfo.insertTimeRange(cnAssetInfo.timeRange, of: cnAssetInfo, at: .zero)
            
            
            self.spatialAudioInfo = try! await CNAssetSpatialAudioInfo(asset: avAsset)
            
            if true {
                for track in try! await avAsset.loadTracks(withMediaType: .audio) {
                    guard let formatDesccription = try! await track.load(.formatDescriptions).first,
                          formatDesccription.mediaType == .audio,
                          formatDesccription.mediaSubType.rawValue == kAudioFormatAPAC
                    else {
                        continue
                    }
                    
                    let newTrack = composition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid)!
                    let timeRange = try! await track.load(.timeRange)
                    try! newTrack.insertTimeRange(timeRange, of: track, at: .zero)
                }
            } else {
                let track = spatialAudioInfo!.defaultSpatialAudioTrack
                let newTrack = composition.addMutableTrack(withMediaType: .audio, preferredTrackID: kCMPersistentTrackID_Invalid)!
                let timeRange = try! await track.load(.timeRange)
                try! newTrack.insertTimeRange(timeRange, of: track, at: .zero)
            }
            
            self.playerItem = AVPlayerItem(asset: composition)
            player.replaceCurrentItem(with: playerItem)
            
            if let playerItem = self.playerItem {
                playerItem.audioMix = spatialAudioInfo!.audioMix(effectIntensity: effectIntensity, renderingStyle: spatialAudioRenderingStyle)
            }
        }
        .onChange(of: spatialAudioRenderingStyle, initial: true) { _, _ in
            if let playerItem {
                playerItem.audioMix = spatialAudioInfo!.audioMix(effectIntensity: effectIntensity, renderingStyle: spatialAudioRenderingStyle)
            }
        }
        .onChange(of: effectIntensity, initial: true) { _, _ in
            if let playerItem {
                playerItem.audioMix = spatialAudioInfo!.audioMix(effectIntensity: effectIntensity, renderingStyle: spatialAudioRenderingStyle)
            }
        }
    }
}

#Preview {
    ContentView()
}

extension CNSpatialAudioRenderingStyle {
    fileprivate var spatialAudioRenderingStyleString: String? {
        switch self {
        case .cinematic: return "Cinematic"
        case .studio: return "Studio"
        case .inFrame: return "In Frame"
        case .cinematicBackgroundStem: return "Cinematic Background Stem"
        case .cinematicForegroundStem: return "Cinematic Foreground Stem"
        case .studioForegroundStem: return "Studio Foreground Stem"
        case .inFrameForegroundStem: return "In Frame Foreground Stem"
        case .standard: return "Standard"
        case .studioBackgroundStem: return "Studio Background Stem"
        case .inFrameBackgroundStem: return "In Frame Background Stem"
        default: return nil
        }
    }
}
