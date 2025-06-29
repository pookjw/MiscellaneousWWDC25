//
//  LabelSpacingView.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 6/29/25.
//

import SwiftUI

struct LabelSpacingView: View {
    var body: some View {
        Label("Hello World!", systemImage: "apple.intelligence")
            .labelReservedIconWidth(300)
            .labelIconToTitleSpacing(100)
    }
}

#Preview {
    LabelSpacingView()
}
