//
//  SafeAreaBarView.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 6/29/25.
//

import SwiftUI

struct SafeAreaBarView: View {
    var body: some View {
        Color.clear
            .ignoresSafeArea()
            .safeAreaBar(edge: VerticalEdge.top, spacing: 100) {
                // Safe Area에서 Spacing 만큼 밀어낸 영역에 View 배치
                Color.green.opacity(0.3)
            }
    }
}

#Preview {
    SafeAreaBarView()
}
