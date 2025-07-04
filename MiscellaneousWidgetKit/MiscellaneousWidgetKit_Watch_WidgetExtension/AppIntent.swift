//
//  AppIntent.swift
//  MiscellaneousWidgetKit_Watch_WidgetExtension
//
//  Created by Jinwoo Kim on 7/4/25.
//

import WidgetKit
import AppIntents

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource { "Configuration" }
    static var description: IntentDescription { "This is an example widget." }

    // An example configurable parameter.
    @Parameter(title: "Favorite Emoji", default: "😃")
    var favoriteEmoji: String
}
