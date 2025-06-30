//
//  OnWorldRecenterView.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 6/30/25.
//

#if os(visionOS)

import SwiftUI

struct OnWorldRecenterView: View {
    var body: some View {
        Text("Hello, World!")
            .onWorldRecenter { event in
                print(event)
            }
    }
}

#Preview {
    OnWorldRecenterView()
}

#endif
