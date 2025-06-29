//
//  ListRowInsetsView.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 6/29/25.
//

import SwiftUI

struct ListRowInsetsView: View {
    var body: some View {
        List {
            ForEach(0..<100) { number in
                Text(String(number))
                    .listRowInsets(.all, 100)
            }
        }
    }
}

#Preview {
    ListRowInsetsView()
}
