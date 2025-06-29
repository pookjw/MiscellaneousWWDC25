//
//  PrimitiveButtonStyleView.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 6/29/25.
//

import SwiftUI

struct PrimitiveButtonStyleView: View {
    var body: some View {
        List {
            Button("Plain", systemImage: "apple.intelligence") {}
                .buttonStyle(.plain)
            Button("Borderless", systemImage: "apple.intelligence") {}
                .buttonStyle(.borderless)
            Button("Bordered", systemImage: "apple.intelligence") {}
                .buttonStyle(.bordered)
            Button("Bordered Prominent", systemImage: "apple.intelligence") {}
                .buttonStyle(.borderedProminent)
            Button("Glass", systemImage: "apple.intelligence") {}
                .buttonStyle(.glass)
            Button("Glass Prominent", systemImage: "apple.intelligence") {}
                .buttonStyle(.glassProminent)
        }
    }
}

#Preview {
    PrimitiveButtonStyleView()
}
