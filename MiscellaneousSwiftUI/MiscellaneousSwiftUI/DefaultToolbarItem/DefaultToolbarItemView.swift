//
//  DefaultToolbarItemView.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 6/29/25.
//

import SwiftUI

#warning("TODO ?????")

struct DefaultToolbarItemView: View {
    @State private var searchText = ""
    var body: some View {
        NavigationSplitView(
            sidebar: { 
                Color.clear
            },
            content: { 
                Color.orange
            },
            detail: { 
                Color.green
            }
        )
            .navigationTitle("Title!")
            .searchable(text: $searchText)
            .toolbar { 
#if !os(watchOS)
                DefaultToolbarItem(kind: .search)
#endif
                DefaultToolbarItem(kind: .sidebarToggle)
#if !os(watchOS)
                DefaultToolbarItem(kind: .title)
#endif
            }
    }
}

#Preview {
    DefaultToolbarItemView()
}
