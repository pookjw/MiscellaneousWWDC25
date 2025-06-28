//
//  Demo.swift
//  MiscellaneousSwiftUI
//
//  Created by Jinwoo Kim on 6/26/25.
//

import SwiftUI

enum Demo: Int, CaseIterable, Identifiable, Hashable {
//    static let defaultCase: Demo = .glassEffectTransitionView
    static let defaultCase: Demo = Demo.allCases.last!
    
    case scrollDemoView
    case glassEffectView
    case glassEffectTransitionView
    
    var id: Int {
        rawValue
    }
    
    @ViewBuilder
    func makeView() -> some View {
        switch self {
        case .scrollDemoView:
            ScrollDemoView()
        case .glassEffectView:
            GlassEffectView()
        case .glassEffectTransitionView:
            GlassEffectTransitionView()
        }
    }
}
