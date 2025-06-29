//
//  SharedBackgroundVisibilityView.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 6/29/25.
//

#if os(iOS) || os(macOS)

import SwiftUI

struct SharedBackgroundVisibilityView: View {
    var body: some View {
        Text("Hello, World!")
            .toolbar { 
                ToolbarItem { 
                    Button("Title", systemImage: "apple.intelligence") {}
                }
                .sharedBackgroundVisibility(.hidden)
                ToolbarItem { 
                    Button("Title", systemImage: "apple.intelligence") {}
                }
            }
    }
}

#Preview {
    SharedBackgroundVisibilityView()
}

#endif
