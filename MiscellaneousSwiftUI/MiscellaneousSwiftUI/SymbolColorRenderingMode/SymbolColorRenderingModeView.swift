//
//  SymbolColorRenderingModeView.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 6/29/25.
//

import SwiftUI

struct SymbolColorRenderingModeView: View {
    var body: some View {
        Image(systemName: "tree.fill")
            .symbolRenderingMode(.multicolor)
            .symbolColorRenderingMode(.gradient)
            .resizable()
            .scaledToFit()
    }
}

#Preview {
    SymbolColorRenderingModeView()
}
