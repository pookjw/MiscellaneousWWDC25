//
//  NavigationSubtitleView.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 6/29/25.
//

#if os(iOS) || os(macOS)

import SwiftUI

struct NavigationSubtitleView: View {
    var body: some View {
        Text("Hello, World!")
            .navigationTitle("Title")
            .navigationSubtitle("Subtitle")
    }
}

#Preview {
    NavigationSubtitleView()
}

#endif
