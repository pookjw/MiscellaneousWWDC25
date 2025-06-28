//
//  ResolvedColorView.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 6/29/25.
//

import SwiftUI

struct ResolvedColorView: View {
    @Environment(\.self) var environmentValues: EnvironmentValues
    
    var body: some View {
        Text("Hello World!")
            .onAppear {
                let resolvedHDR = Color.blue.resolveHDR(in: environmentValues)
                for child in Mirror(reflecting: resolvedHDR).children {
                    print(child)
                }
            }
    }
}

#Preview {
    ResolvedColorView()
}
