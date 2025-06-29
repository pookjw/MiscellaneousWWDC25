//
//  ToolbarSpacerView.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 6/29/25.
//

#if os(iOS) || os(macOS)

import SwiftUI

struct ToolbarSpacerView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .toolbar { 
                ToolbarItem { 
                    Button("1", systemImage: "apple.intelligence") {}
                }
                
                ToolbarItem { 
                    Button("2", systemImage: "apple.intelligence") {}
                }
                
                ToolbarSpacer(.flexible)
                
                ToolbarItem { 
                    Button("3", systemImage: "apple.intelligence") {}
                }
                
                ToolbarItem { 
                    Button("4", systemImage: "apple.intelligence") {}
                }
            }
    }
}

#Preview {
    ToolbarSpacerView()
}

#endif
