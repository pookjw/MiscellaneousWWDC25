//
//  ControlSizeView.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 6/29/25.
//

import SwiftUI

struct ControlSizeView: View {
#if os(watchOS)
    @State private var isConfigurationPresented = false
#endif
    @State private var minControlSize: ControlSize = .extraLarge
    @State private var maxControlSize: ControlSize = .extraLarge
    
    var body: some View {
        Button("Apple Intelligence", systemImage: "apple.intelligence", action: {})
            .buttonStyle(.glassProminent)
            .controlSize(minControlSize...maxControlSize)
#if os(watchOS)
            .sheet(isPresented: $isConfigurationPresented) {
                NavigationStack {
                    List {
                        configuration
                    }
                }
            }
#endif
            .toolbar { 
                menuToolbarItem
            }
    }
    
    @ToolbarContentBuilder
    private var menuToolbarItem: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) { 
#if os(watchOS)
            Button {
                isConfigurationPresented = true
            } label: { 
                Label("Menu", systemImage: "filemenu.and.selection")
            }
#else
            Menu {
                configuration
            } label: { 
                Label("Menu", systemImage: "filemenu.and.selection")
            }
#endif
        }
    }
    
    
    @ViewBuilder
    private var configuration: some View {
        Picker("Min Control Size", selection: $minControlSize) { 
            ForEach(ControlSize.allCases, id: \.self) { controlSize in
                Text(String(describing: controlSize))
                    .id(controlSize)
            }
        }
        
        Picker("Max Control Size", selection: $maxControlSize) { 
            ForEach(ControlSize.allCases, id: \.self) { controlSize in
                Text(String(describing: controlSize))
                    .id(controlSize)
            }
        }
    }
}

#Preview {
    ControlSizeView()
}
