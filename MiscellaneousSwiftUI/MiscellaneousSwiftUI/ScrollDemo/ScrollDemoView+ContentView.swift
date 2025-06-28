//
//  ScrollDemoView+ContentView.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 6/26/25.
//

import SwiftUI

extension ScrollDemoView {
    struct ContentView: View {
        var body: some View {
            LazyVStack(spacing: 0) {
                ForEach(0..<50) { row in
                    LazyHStack(spacing: 0) { 
                        ForEach(0..<50) { column in
                            Text(String((row * 50) + column))
                                .font(.system(size: 20))
                                .foregroundStyle(Color.white)
                                .containerRelativeFrame(.horizontal)
                                .frame(height: 500)
                                .background {
                                    ((column + row) % 2 == 0) ? Color.blue : Color.orange
                                }
                                .id((row * 50) + column)
                        }
                    }
                    .scrollTargetLayout()
                }
            }
            .scrollTargetLayout()
        }
    }
}
