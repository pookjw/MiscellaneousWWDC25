//
//  BackgroundExtensionEffectView.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 6/29/25.
//

import SwiftUI

struct BackgroundExtensionEffectView: View {
    var body: some View {
        NavigationSplitView { 
            Color.clear
        } detail: { 
            Image("0")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .backgroundExtensionEffect()
        }

    }
}

#Preview {
    BackgroundExtensionEffectView()
}
