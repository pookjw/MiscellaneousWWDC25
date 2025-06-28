//
//  DebugReplaceableDemoView.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 6/28/25.
//

import SwiftUI

struct DebugReplaceableDemoView: View {
    @State private var flag = false
    var body: some View {
        VStack(alignment: .center) {
            DebugReplaceableView(erasing: flag ? AnyView(Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)) : AnyView(Image(systemName: "apple.intelligence")))
            Toggle(isOn: $flag) {}
        }
    }
}

#Preview {
    DebugReplaceableDemoView()
}
