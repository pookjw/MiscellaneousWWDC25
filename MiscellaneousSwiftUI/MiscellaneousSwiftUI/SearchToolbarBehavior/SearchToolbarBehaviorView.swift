//
//  SearchToolbarBehaviorView.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 6/29/25.
//

#if os(iOS)

import SwiftUI

#warning("TODO ??????")

struct SearchToolbarBehaviorView: View {
    @State private var text = ""
    @State private var searchToolbarBehavior: SearchToolbarBehavior = .minimize
    
    var body: some View {
        NavigationSplitView(
            sidebar: { 
                Color.clear
            },
            content: {
                Color.clear
                    .searchable(text: $text)
                    .searchToolbarBehavior(searchToolbarBehavior)
            },
            detail: { 
                Color.clear
            }
        )
        .searchToolbarBehavior(searchToolbarBehavior)
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
        Picker(selection: $searchToolbarBehavior) { 
            ForEach([SearchToolbarBehavior.automatic, SearchToolbarBehavior.minimize], id: \.self) { behavior in
                Text(String(describing: behavior))
                    .id(behavior)
            }
        } label: { 
            
        }
    }
}

#Preview {
    SearchToolbarBehaviorView()
}

#endif
