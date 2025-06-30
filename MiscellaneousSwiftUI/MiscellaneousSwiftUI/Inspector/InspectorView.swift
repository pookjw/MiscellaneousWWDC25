//
//  InspectorView.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 6/30/25.
//

#if os(macOS) || os(iOS)

import SwiftUI

struct InspectorView: View {
    @State private var isPresented = false
    
    var body: some View {
        NavigationSplitView { 
            Color.green
        } detail: { 
            Toggle(isOn: $isPresented) {}
        }
        .inspector(isPresented: $isPresented) { 
            Color.orange
        }
        .inspectorColumnWidth(100)
    }
}

#Preview {
    InspectorView()
}

#endif
