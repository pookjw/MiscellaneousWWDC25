//
//  ContentCaptureProtectedView.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 6/30/25.
//

#if os(visionOS)

import SwiftUI

struct ContentCaptureProtectedView: View {
    var body: some View {
        Text("Hello, World!")
            .contentCaptureProtected(true)
    }
}

#Preview {
    ContentCaptureProtectedView()
}

#endif
