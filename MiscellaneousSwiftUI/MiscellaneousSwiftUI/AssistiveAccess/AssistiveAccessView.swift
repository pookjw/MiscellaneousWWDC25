//
//  AssistiveAccessView.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 6/29/25.
//

import SwiftUI

struct AssistiveAccessView: View {
    @Environment(\.accessibilityAssistiveAccessEnabled) private var accessibilityAssistiveAccessEnabled
    
    var body: some View {
        Text("accessibilityAssistiveAccessEnabled : \(String(accessibilityAssistiveAccessEnabled))")
            .assistiveAccessNavigationIcon(systemImage: "apple.intelligence")
    }
}

#Preview {
    AssistiveAccessView()
}
