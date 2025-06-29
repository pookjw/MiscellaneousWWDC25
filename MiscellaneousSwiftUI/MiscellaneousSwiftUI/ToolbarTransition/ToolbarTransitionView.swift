//
//  ToolbarTransitionView.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 6/29/25.
//

#if os(iOS)

import SwiftUI

struct ToolbarTransitionView: View {
    @State private var isPresented = false
    @Namespace private var namspace
    
    var body: some View {
        Text("Hello, World!")
            .toolbar {
                ToolbarItem { 
                    Button("Button", systemImage: "apple.inteliigence") { 
                        isPresented = true
                    }
                }
                .matchedTransitionSource(id: "id", in: namspace)
            }
            .sheet(isPresented: $isPresented) { 
                Color.orange
                    .ignoresSafeArea()
                    .navigationTransition(ZoomNavigationTransition.zoom(sourceID: "id", in: namspace))
            }
    }
}

#Preview {
    ToolbarTransitionView()
}

#endif
