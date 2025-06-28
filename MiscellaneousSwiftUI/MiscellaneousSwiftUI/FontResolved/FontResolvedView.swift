//
//  FontResolvedView.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 6/29/25.
//

import SwiftUI

struct FontResolvedView: View {
    @Environment(\.fontResolutionContext) private var fontResolutionContext
    
    var body: some View {
        Button("Boo") {
            // <UICTFont: 0x105f2a470> font-family: "UICTFontTextStyleTitle0"; font-weight: normal; font-style: normal; font-size: 34.00pt
            print(Font.system(.largeTitle).resolve(in: fontResolutionContext).ctFont)
        }
    }
}

#Preview {
    FontResolvedView()
}
