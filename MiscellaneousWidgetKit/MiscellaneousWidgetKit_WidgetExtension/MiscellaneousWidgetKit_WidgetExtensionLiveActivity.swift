//
//  MiscellaneousWidgetKit_WidgetExtensionLiveActivity.swift
//  MiscellaneousWidgetKit_WidgetExtension
//
//  Created by Jinwoo Kim on 7/3/25.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct MiscellaneousWidgetKit_WidgetExtensionAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct MiscellaneousWidgetKit_WidgetExtensionLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: MiscellaneousWidgetKit_WidgetExtensionAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension MiscellaneousWidgetKit_WidgetExtensionAttributes {
    fileprivate static var preview: MiscellaneousWidgetKit_WidgetExtensionAttributes {
        MiscellaneousWidgetKit_WidgetExtensionAttributes(name: "World")
    }
}

extension MiscellaneousWidgetKit_WidgetExtensionAttributes.ContentState {
    fileprivate static var smiley: MiscellaneousWidgetKit_WidgetExtensionAttributes.ContentState {
        MiscellaneousWidgetKit_WidgetExtensionAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: MiscellaneousWidgetKit_WidgetExtensionAttributes.ContentState {
         MiscellaneousWidgetKit_WidgetExtensionAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: MiscellaneousWidgetKit_WidgetExtensionAttributes.preview) {
   MiscellaneousWidgetKit_WidgetExtensionLiveActivity()
} contentStates: {
    MiscellaneousWidgetKit_WidgetExtensionAttributes.ContentState.smiley
    MiscellaneousWidgetKit_WidgetExtensionAttributes.ContentState.starEyes
}
