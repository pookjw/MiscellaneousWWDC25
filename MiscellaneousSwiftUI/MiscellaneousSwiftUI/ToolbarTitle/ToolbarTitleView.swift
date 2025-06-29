//
//  ToolbarTitleView.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 6/29/25.
//

#if os(iOS)

import SwiftUI

struct ToolbarTitleView: View {
    var body: some View {
        List(0..<500) { number in
            Text(String(number))
        }
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .largeTitle) { 
                Text("Large Title!")
                    .foregroundStyle(Color.orange)
            }
            ToolbarItem(placement: .largeSubtitle) { 
                Text("Large Subtitle!")
                    .foregroundStyle(Color.green)
            }
            ToolbarItem(placement: .title) { 
                Text("Title!")
                    .foregroundStyle(Color.blue)
            }
        }
    }
}

#Preview {
    ToolbarTitleView()
}

#endif
