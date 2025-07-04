//
//  WidgetCenterView.swift
//  MiscellaneousWidgetKit
//
//  Created by Jinwoo Kim on 7/4/25.
//

import SwiftUI
import WidgetKit

struct WidgetCenterView: View {
    var body: some View {
        Button("reloadAllTimelines") {
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
}
