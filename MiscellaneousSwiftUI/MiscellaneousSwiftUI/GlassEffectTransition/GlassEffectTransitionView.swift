//
//  GlassEffectTransitionView.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 6/28/25.
//

#if !os(visionOS)

import SwiftUI

struct GlassEffectTransitionView: View {
    @State private var flag = false
    @Namespace var namespace
    
    var body: some View {
        Image("image")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .ignoresSafeArea()
            .overlay(alignment: .center) {
                GlassEffectContainer { 
                    if !flag {
                        VStack {
                            Text("Hello World!")
                                .font(.largeTitle)
                                .glassEffect(.regular)
                                .glassEffectUnion(id: "123", namespace: namespace)
                            
                            Text("Hello World!")
                                .font(.largeTitle)
                                .glassEffect(.regular)
                                .glassEffectUnion(id: "123", namespace: namespace)
                            
                            Text("Hello World!")
                                .font(.largeTitle)
                                .glassEffect(.regular)
                                .glassEffectID("id", in: namespace)
                                .glassEffectTransition(.matchedGeometry(properties: .frame, anchor: .top))
                                .matchedGeometryEffect(id: "frame", in: namespace, properties: .frame)
                                .glassEffectUnion(id: "456", namespace: namespace)
                        }
                    } else {
                        Text("Hello World!")
                            .font(.largeTitle)
                            .padding(100)
                            .glassEffect(.regular)
                            .glassEffectID("id", in: namespace)
                            .glassEffectTransition(.matchedGeometry(properties: .frame, anchor: .top))
                            .matchedGeometryEffect(id: "frame", in: namespace, properties: .frame)
                    }
                }
            }
            .animation(.easeInOut(duration: 3), value: flag)
            .toolbar { 
                ToolbarItem {
                    Button("Toggle", systemImage: "apple.intelligence") { 
                        flag.toggle()
                    }
                }
            }
    }
}

#Preview {
    GlassEffectTransitionView()
}

#endif
