//
//  ScrollInputKindView.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 6/30/25.
//

#if os(watchOS) || os(visionOS)

import SwiftUI

struct ScrollInputKindView: View {
    var body: some View {
        List(0..<500) { number in
            Text(String(number))
        }
#if os(visionOS)
        .scrollInputBehavior(.enabled, for: .look(axes: [.horizontal, .vertical]))
#elseif os(watchOS)
        .scrollInputBehavior(.enabled, for: .handGestureShortcut)
#endif
    }
}

#Preview {
    ScrollInputKindView()
}

#endif
