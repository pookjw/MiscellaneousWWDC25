//
//  MiscellaneousWidgetKit_Watch_WidgetExtension.swift
//  MiscellaneousWidgetKit_Watch_WidgetExtension
//
//  Created by Jinwoo Kim on 7/4/25.
//

import WidgetKit
import SwiftUI
import RelevanceKit
import AppIntents

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }

    func recommendations() -> [AppIntentRecommendation<ConfigurationAppIntent>] {
        [
            AppIntentRecommendation(intent: ConfigurationAppIntent(), description: "Example Widget 1"),
            AppIntentRecommendation(intent: ConfigurationAppIntent(), description: "Example Widget 2"),
        ]
    }

    func relevances() async -> WidgetRelevance<ConfigurationAppIntent> {
        WidgetRelevance<ConfigurationAppIntent>([
            WidgetRelevanceAttribute<ConfigurationAppIntent>(configuration: ConfigurationAppIntent(), group: WidgetRelevanceGroup.named("Group")),
            WidgetRelevanceAttribute<ConfigurationAppIntent>(configuration: ConfigurationAppIntent(), group: WidgetRelevanceGroup.named("Group"))
        ])
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
}

struct MiscellaneousWidgetKit_Watch_WidgetExtensionEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            HStack {
                Text("Time:")
                Text(entry.date, style: .time)
            }
        
            Text("Favorite Emoji:")
            Text(entry.configuration.favoriteEmoji)
        }
    }
}

struct MiscellaneousWidgetKit_Watch_WidgetExtension: Widget {
    let kind: String = "MiscellaneousWidgetKit_Watch_WidgetExtension"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            MiscellaneousWidgetKit_Watch_WidgetExtensionEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
    }
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }
    
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "🤩"
        return intent
    }
}

#Preview(as: .accessoryRectangular) {
    MiscellaneousWidgetKit_Watch_WidgetExtension()
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley)
    SimpleEntry(date: .now, configuration: .starEyes)
}    
