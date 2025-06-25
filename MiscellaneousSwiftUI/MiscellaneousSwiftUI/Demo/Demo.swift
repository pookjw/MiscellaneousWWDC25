//
//  Demo.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 6/26/25.
//

import SwiftUI

enum Demo: Int, Identifiable, CaseIterable {
    case test
    
    var id: Int {
        rawValue
    }
    
    @ViewBuilder
    func makeView() -> some View {
        switch self {
        case .test:
            Text("Test")
        }
    }
}
