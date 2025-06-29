//
//  AttributedTextEditorView.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 6/29/25.
//

#if os(iOS) || os(macOS) || os(visionOS)

import SwiftUI

struct AttributedTextEditorView: View {
    @State private var attributedText: AttributedString = .init(stringLiteral: "")
    @State private var selection: AttributedTextSelection = .init()
    
    var body: some View {
        TextEditor(text: $attributedText, selection: $selection)
            .textInputFormattingControlVisibility(.visible, for: [.contextMenu, .default, .inputAssistant])
            .onChange(of: selection, initial: false) { oldValue, newValue in
                print(newValue)
            }
    }
}

#Preview {
    AttributedTextEditorView()
}

#endif
