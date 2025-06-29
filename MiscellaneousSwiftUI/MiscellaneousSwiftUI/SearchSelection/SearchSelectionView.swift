//
//  SearchSelectionView.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 6/29/25.
//

#if os(iOS) || os(macOS) || os(visionOS)

import SwiftUI

struct SearchSelectionView: View {
    @State private var searchText: String = "ABCDEFG"
    @State private var searchSelection: TextSelection?
    
    var body: some View {
        Text("Hello, World!")
            .searchable(text: $searchText)
            .searchSelection($searchSelection)
            .onChange(of: searchSelection, initial: false) { oldValue, newValue in
                if let newValue {
                    print(newValue)
                }
            }
    }
}

#Preview {
    SearchSelectionView()
}

#endif
