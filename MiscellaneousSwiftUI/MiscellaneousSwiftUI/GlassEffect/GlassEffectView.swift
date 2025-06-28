//
//  GlassEffectView.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 6/27/25.
//

import SwiftUI

struct GlassEffectView: View {
#if os(watchOS)
    @State private var isConfigurationPresented = false
#endif
    @State private var glass: Glass = .regular.interactive(true)
    @State private var tintColor: Color?
    
    var body: some View {
        Image("0")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .ignoresSafeArea()
            .overlay(alignment: .center) { 
                Text("Hello World!")
                    .font(.largeTitle)
                    .padding()
                    .glassEffect(glass, in: .capsule, isEnabled: true)
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
            .onChange(of: tintColor, initial: true) { oldValue, newValue in
                if let newValue {
                    glass = glass.tint(newValue)
                }
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
#if os(watchOS)
        NavigationLink("Glass") {
            List {
                glassConfiguration
            }
        }
#else
        Menu("Glass") { 
            glassConfiguration
        }
#endif
    }
    
    @ViewBuilder
    private var glassConfiguration: some View {
        Button("Regular") { 
            glass = .regular
        }
        
        Button("Add Interactive") { 
            glass = glass.interactive()
        }
        
#if os(watchOS)
        Button("Set Tint Color as Green") { 
            tintColor = .green.opacity(0.5)
        }
        
        Button("Remove Tint Color") { 
            tintColor = nil
        }
#else
        ColorPicker(
            "Tint Color",
            selection: Binding(
                get: {
                    tintColor ?? .clear
                },
                set: { newValue in
                    tintColor = newValue
                }
            )
        )
#endif
    }
}

#Preview {
    GlassEffectView()
}
