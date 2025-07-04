//
//  MyWidgetCenterView.swift
//  MiscellaneousWidgetKit
//
//  Created by Jinwoo Kim on 7/4/25.
//

import SwiftUI

struct MyWidgetCenterView: View {
    var body: some View {
        List {
            Button("reloadTimelinesOfKind:inBundle:completion:") {
                Task {
                    try! await MyWidgetCenter.shared.reloadAllTimelines(ofKind: "MiscellaneousWidgetKit_Watch_WidgetExtension", inBundle: "com.pookjw.MiscellaneousWidgetKit.watchkitapp.WidgetExtension")
                }
            }
            
            Button("invalidateConfigurationRecommendationsWithCompletion") {
                Task {
                    try! await MyWidgetCenter.shared.invalidateConfigurationRecommendations()
                }
            }
            
            Button("invalidateConfigurationRecommendationsInBundle:completion:") {
                Task {
                    try! await MyWidgetCenter.shared.invalidateConfigurationRecommendations(inBundle: "com.pookjw.MiscellaneousWidgetKit.watchkitapp.WidgetExtension")
                }
            }
            
            Button("invalidateRelevancesOfKind:completionHandler:") {
                Task {
                    try! await MyWidgetCenter.shared.invalidateRelevances(ofKind: "MiscellaneousWidgetKit_Watch_WidgetExtension")
                }
            }
            
            Button("invalidateRelevancesOfKind:inBundle:completionHandler:") {
                Task {
                    try! await MyWidgetCenter.shared.invalidateRelevances(ofKind: "MiscellaneousWidgetKit_Watch_WidgetExtension", inBundle: "com.pookjw.MiscellaneousWidgetKit.watchkitapp.WidgetExtension")
                }
            }
        }
    }
}
