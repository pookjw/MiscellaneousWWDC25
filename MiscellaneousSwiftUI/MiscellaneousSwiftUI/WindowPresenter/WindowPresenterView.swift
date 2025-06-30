//
//  WindowPresenterView.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 6/30/25.
//

#if os(macOS) || os(visionOS)

import SwiftUI

struct WindowPresenterView: View {
    @Environment(\.openWindow) private var openWindow
    
    var body: some View {
        Button("Open") { 
            openWindow(id: "Window")
        }
    }
}

#Preview {
    WindowPresenterView()
}

#endif
