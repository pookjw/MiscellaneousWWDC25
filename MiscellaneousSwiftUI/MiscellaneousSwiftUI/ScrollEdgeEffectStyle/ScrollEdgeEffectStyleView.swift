//
//  ScrollEdgeEffectStyleView.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 6/29/25.
//

#if !os(visionOS)

import SwiftUI

struct ScrollEdgeEffectStyleView: View {
#if os(watchOS)
    @State private var isConfigurationPresented = false
#endif
    @State private var style: ScrollEdgeEffectStyle = .automatic
    @State private var disabled = false
    
    var body: some View {
        ScrollView([.horizontal, .vertical]) {
            Image("0")
        }
        .scrollEdgeEffectStyle(.hard, for: .all)
        .scrollEdgeEffectDisabled(disabled, for: .all)
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
        ToolbarItem { 
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
        Picker(selection: $style) { 
            ForEach([ScrollEdgeEffectStyle.automatic, ScrollEdgeEffectStyle.soft, ScrollEdgeEffectStyle.hard], id: \.self) { style in
                Text(String(describing: style))
                    .id(style)
            }
        } label: { 
            
        }
        
        Text("Changing value at runtime is not working")
        
        Toggle(isOn: $disabled) { 
            Text("disabled")
        }
    }
}

#Preview {
    ScrollEdgeEffectStyleView()
}

#endif
