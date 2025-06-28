//
//  AccessibilityCustomContentView.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 6/28/25.
//

import SwiftUI

struct AccessibilityCustomContentView: View {
    var body: some View {
        VStack {
            Text("Hello, World!")
            Text("Hello, World!")
            Text("Hello, World!")
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(Text("Accessibility Label"))
        .accessibilityCustomContent(
            AccessibilityCustomContentKey("Label 0"),
            "Value 0",
            importance: .high
        )
        .accessibilityCustomContent(
            AccessibilityCustomContentKey("Label 1"),
            "Value 1",
            importance: .high
        )
        .accessibilityCustomContent(
            AccessibilityCustomContentKey("Label 2"),
            "Value 2",
            importance: .default
        )
        .accessibilityCustomContent(
            AccessibilityCustomContentKey("Label 3"),
            "Value 3",
            importance: .default
        )
        .accessibilityCustomContent(
            AccessibilityCustomContentKey("Label 4"),
            "Value 4",
            importance: .default
        )
        .accessibilityCustomContent(
            AccessibilityCustomContentKey("Label 5"),
            "Value 5",
            importance: .default
        )
        .accessibilityCustomContent(
            AccessibilityCustomContentKey("Label 6"),
            "Value 6",
            importance: .default
        )
        .accessibilityCustomContent(
            AccessibilityCustomContentKey("Label 7"),
            "Value 7",
            importance: .default
        )
        .accessibilityCustomContent(
            AccessibilityCustomContentKey("Label 8"),
            "Value 8",
            importance: .default
        )
        .accessibilityCustomContent(
            AccessibilityCustomContentKey("Label 9"),
            "Value 9",
            importance: .default
        )
    }
}

#Preview {
    AccessibilityCustomContentView()
}
