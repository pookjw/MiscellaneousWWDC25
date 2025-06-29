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
    case openURLActionView
    case buttonSizingView
    case debugReplaceableDemoView
    case accessibilityCustomContentView
    case animatableValuesView
    case controlSizeView
    case symbolVariableValueModeView
    case symbolColorRenderingModeView
    case resolvedColorView
#if !os(watchOS)
    case headroomAndExposureView
#endif
    case fontResolvedView
    
#if !os(watchOS)
    case caLayerDemoView
#endif
    
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
        case .openURLActionView:
            OpenURLActionView()
        case .buttonSizingView:
            ButtonSizingView()
        case .debugReplaceableDemoView:
            DebugReplaceableDemoView()
        case .accessibilityCustomContentView:
            AccessibilityCustomContentView()
        case .animatableValuesView:
            AnimatableValuesView()
        case .controlSizeView:
            ControlSizeView()
        case .symbolVariableValueModeView:
            SymbolVariableValueModeView()
        case .symbolColorRenderingModeView:
            SymbolColorRenderingModeView()
        case .resolvedColorView:
            ResolvedColorView()
#if !os(watchOS)
        case .headroomAndExposureView:
            HeadroomAndExposureView()
#endif
        case .fontResolvedView:
            FontResolvedView()
#if !os(watchOS)
        case .caLayerDemoView:
            CALayerDemoView()
#endif
        }
    }
}
