//
//  impls.swift
//  MiscellaneousWidgetKit
//
//  Created by Jinwoo Kim on 7/3/25.
//

import WidgetKit

@_cdecl("WidgetCenter_reloadAllTimelines")
func reload() {
    WidgetCenter.shared.reloadAllTimelines()
}

@_cdecl("WidgetCenter_currentConfigurations")
func currentConfigurations() {
    Task {
        try! await WidgetCenter.shared.currentConfigurations()
    }
}
