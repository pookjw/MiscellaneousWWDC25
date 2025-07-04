//
//  MiscellaneousWidgetKit_Watch_WidgetExtensionBundle.swift
//  MiscellaneousWidgetKit_Watch_WidgetExtension
//
//  Created by Jinwoo Kim on 7/4/25.
//

import WidgetKit
import SwiftUI

@main
struct MiscellaneousWidgetKit_Watch_WidgetExtensionBundle: WidgetBundle {
    var body: some Widget {
        MiscellaneousWidgetKit_Watch_WidgetExtension()
        MiscellaneousWidgetKit_Watch_WidgetExtensionControl()
    }
}
