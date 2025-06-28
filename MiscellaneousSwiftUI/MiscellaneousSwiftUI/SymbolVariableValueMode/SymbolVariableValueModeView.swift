//
//  SymbolVariableValueModeView.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 6/29/25.
//

import SwiftUI

struct SymbolVariableValueModeView: View {
    @State private var variableValue: Double = 0
    var body: some View {
        VStack {
            Image(systemName: "stop.circle", variableValue: variableValue)
                .symbolVariableValueMode(.draw)
                .font(.largeTitle)
            
            Image(systemName: "rectangle.and.pencil.and.ellipsis", variableValue: variableValue)
                .symbolVariableValueMode(.color)
                .font(.largeTitle)
            
            Stepper(value: $variableValue, in: 0...1, step: 0.1, label: {})
        }
    }
}

#Preview {
    SymbolVariableValueModeView()
}
