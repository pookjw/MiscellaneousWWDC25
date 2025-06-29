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
#if !os(visionOS)
    case glassEffectView
    case glassEffectTransitionView
#endif
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
    
#if os(iOS) || os(macOS)
    case toolbarSpacerView
#endif
    case sensoryFeedbackView
#if os(iOS) || os(macOS) || os(visionOS)
    case searchSelectionView
#endif
    case listRowInsetsView
    case primitiveButtonStyleView
#if os(iOS) || os(macOS) || os(visionOS)
    case findContextView
    case attributedTextEditorView
#endif
    case sectionIndexTitleView
#if os(iOS) || os(macOS)
    case sharedBackgroundVisibilityView
#endif
#if os(iOS)
    case toolbarTitleView
#endif
    case defaultToolbarItemView
    case tabBarView
    case buttonRoleView
    case backgroundExtensionEffectView
#if !os(visionOS)
    case scrollEdgeEffectStyleView
#endif
    case assistiveAccessView
#if os(iOS)
    case toolbarTransitionView
#endif
    case safeAreaBarView
    
#if os(iOS) || os(macOS)
    case navigationSubtitleView
#endif
#if os(iOS)
    case searchToolbarBehaviorView
#endif
    case labelSpacingView
#if os(visionOS)
    case customHoverEffectView
#endif
    
    var id: Int {
        rawValue
    }
    
    @ViewBuilder
    func makeView() -> some View {
        switch self {
        case .scrollDemoView:
            ScrollDemoView()
#if !os(visionOS)
        case .glassEffectView:
            GlassEffectView()
        case .glassEffectTransitionView:
            GlassEffectTransitionView()
#endif
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
#if os(iOS) || os(macOS)
        case .toolbarSpacerView:
            ToolbarSpacerView()
#endif
        case .sensoryFeedbackView:
            SensoryFeedbackView()
#if os(iOS) || os(macOS) || os(visionOS)
        case .searchSelectionView:
            SearchSelectionView()
#endif
        case .listRowInsetsView:
            ListRowInsetsView()
        case .primitiveButtonStyleView:
            PrimitiveButtonStyleView()
#if os(iOS) || os(macOS) || os(visionOS)
        case .findContextView:
            FindContextView()
        case .attributedTextEditorView:
            AttributedTextEditorView()
#endif
        case .sectionIndexTitleView:
            SectionIndexTitleView()
#if os(iOS) || os(macOS)
        case .sharedBackgroundVisibilityView:
            SharedBackgroundVisibilityView()
#endif
#if os(iOS)
        case .toolbarTitleView:
            ToolbarTitleView()
#endif
        case .defaultToolbarItemView:
            DefaultToolbarItemView()
        case .tabBarView:
            TabBarView()
        case .buttonRoleView:
            ButtonRoleView()
        case .backgroundExtensionEffectView:
            BackgroundExtensionEffectView()
#if !os(visionOS)
        case .scrollEdgeEffectStyleView:
            ScrollEdgeEffectStyleView()
#endif
        case .assistiveAccessView:
            AssistiveAccessView()
#if os(iOS)
        case .toolbarTransitionView:
            ToolbarTransitionView()
#endif
        case .safeAreaBarView:
            SafeAreaBarView()
#if os(iOS) || os(macOS)
        case .navigationSubtitleView:
            NavigationSubtitleView()
#endif
#if os(iOS)
        case .searchToolbarBehaviorView:
            SearchToolbarBehaviorView()
#endif
        case .labelSpacingView:
            LabelSpacingView()
        case .customHoverEffectView:
            CustomHoverEffectView()
    }
}
