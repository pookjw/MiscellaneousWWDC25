//
//  MiscellaneousWidgetKit_WidgetExtension.swift
//  MiscellaneousWidgetKit_WidgetExtension
//
//  Created by Jinwoo Kim on 7/3/25.
//

import WidgetKit
import SwiftUI
import RelevanceKit
import WidgetKitPrivate
import AppIntents

struct Provider: AppIntentTimelineProvider {
    func recommendations() -> [AppIntentRecommendation<ConfigurationAppIntent>] {
        []
    }
    
    func relevance() async -> WidgetRelevance<ConfigurationAppIntent> {
        WidgetRelevance([
            .init(configuration: .smiley, context: .date(.now))
        ])
    }
    
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
}

struct StaticProvider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        .init(date: .now, configuration: .smiley)
    }
    
    func getSnapshot(in context: Context, completion: @escaping @Sendable (SimpleEntry) -> Void) {
        completion(.init(date: .now, configuration: .smiley))
    }
    
    func getTimeline(in context: Context, completion: @escaping @Sendable (Timeline<SimpleEntry>) -> Void) {
        completion(.init(entries: [.init(date: .now, configuration: .smiley)], policy: .never))
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
}

struct MiscellaneousWidgetKit_WidgetExtensionEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack {
            Text("Time:")
            Text(entry.date, style: .time)
            
            Text("Favorite Emoji:")
            Text(entry.configuration.favoriteEmoji)
        }
    }
}

struct MiscellaneousWidgetKit_WidgetExtension: Widget {
    let kind: String = "MiscellaneousWidgetKit_WidgetExtension"
    
    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            MiscellaneousWidgetKit_WidgetExtensionEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
            
        }
    }
}

struct MiscellaneousWidgetKit_StaticWidgetExtension: Widget {
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: "Static", provider: StaticProvider()) { entry in
            Text("Hello World!")
        }
    }
}

struct MiscellaneousWidgetKit_LiveWidgetExtension: Widget {
    let kind: String = "Static"
    
    var body: some WidgetConfiguration {
        LiveSceneWidgetConfiguration(kind)
            .configurationDisplayName(Text("Live"))
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
