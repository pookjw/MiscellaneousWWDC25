//
//  FindContextView.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 6/29/25.
//

#if os(iOS) || os(macOS) || os(visionOS)

#warning("TODO ??????")

import SwiftUI

struct FindContextView: View {
    @Environment(\.findContext) private var findContext
    
    var body: some View {
        VStack {
            _MyTextEditor()
                .overlay(alignment: .center) { 
                    if let findContext {
                        if let isPresented = findContext.isPresented {
                            Toggle(isOn: isPresented) {
                                Text("Presented")
                            }
                        }
                        
                        Text("supportsReplace : \(String(findContext.supportsReplace))")
                    }
                }
        }
    }
}

fileprivate struct _MyTextEditor: View {
    @State private var text: String = ""
    @State private var replaceDisabled = false
    @State private var findNavigatorIsPresnted = false
    var body: some View {
        VStack {
            Toggle(isOn: $findNavigatorIsPresnted) { Text("findNavigatorIsPresnted") }
            Toggle(isOn: $replaceDisabled) { Text("replaceDisabled") }
            
            TextEditor(text: $text)
                .replaceDisabled(replaceDisabled) // findNavigator 위에 있어야 작동함
                .findNavigator(isPresented: $findNavigatorIsPresnted)
        }
    }
}

fileprivate struct _FindContextView: View {
    @Environment(\.findContext) private var findContext
    
    var body: some View {
        if let findContext {
            if let isPresented = findContext.isPresented {
                Toggle(isOn: isPresented) {
                    Text("Presented")
                }
            }
            
            Text("supportsReplace : \(String(findContext.supportsReplace))")
        }
    }
}

#Preview {
    FindContextView()
}

#endif
