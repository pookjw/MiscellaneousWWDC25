//
//  MiscellaneousWidgetKit_WidgetExtensionBundle.swift
//  MiscellaneousWidgetKit_WidgetExtension
//
//  Created by Jinwoo Kim on 7/3/25.
//

import WidgetKit
import SwiftUI

@main
struct MiscellaneousWidgetKit_WidgetExtensionBundle: WidgetBundle {
    init() {
        Task {
            try! await Task.sleep(for: .seconds(3))
            mwk_test()
        }
    }
    
    var body: some Widget {
        MiscellaneousWidgetKit_WidgetExtension()
        
#if os(iOS)
        MiscellaneousWidgetKit_WidgetExtensionControl()
        MiscellaneousWidgetKit_WidgetExtensionLiveActivity()
#endif
    }
}
