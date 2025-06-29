//
//  ButtonSizingView.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 6/28/25.
//

import SwiftUI

struct ButtonSizingView: View {
#if os(watchOS)
    @State private var isConfigurationPresented = false
#endif
    @State private var buttonSizing: ButtonSizing = .fitted
    
    var body: some View {
        VStack {
            Button("Apple Intelligence", systemImage: "apple.intelligence", action: {})
                .buttonStyle(.glassProminent)
                .buttonSizing(buttonSizing)
            
            _ButtonSizingView()
                .buttonSizing(buttonSizing)
        }
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
        Picker("Button Sizing", selection: $buttonSizing) { 
            ForEach([ButtonSizing.automatic, ButtonSizing.flexible, ButtonSizing.fitted], id: \.self) { buttonSizing in
                Text(String(describing: buttonSizing))
                    .id(buttonSizing)
            }
        }
    }
}

fileprivate struct _ButtonSizingView: View {
    @Environment(\.buttonSizing) private var buttonSizing
    
    var body: some View {
        Text(String(describing: buttonSizing))
    }
}

#Preview {
    ButtonSizingView()
}
