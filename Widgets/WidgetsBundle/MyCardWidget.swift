//
//  MyCardWidget.swift
//  Widgets
//
//  Created by kimhyungyu on 2023/02/04.
//

import WidgetKit
import SwiftUI
import Intents

struct MyCardProvider: IntentTimelineProvider {
    func placeholder(in context: Context) -> MyCardEntry {
        MyCardEntry(date: Date(), configuration: MyCardIntent())
    }

    func getSnapshot(for configuration: MyCardIntent, in context: Context, completion: @escaping (MyCardEntry) -> Void) {
        let entry = MyCardEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: MyCardIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        var entries: [MyCardEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = MyCardEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct MyCardEntry: TimelineEntry {
    let date: Date
    let configuration: MyCardIntent
}

struct MyCardEntryView: View {
    var entry: MyCardProvider.Entry

    var body: some View {
        Text(entry.date, style: .time)
    }
}

struct MyCardWidget: Widget {
    let kind: String = "Widgets"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: MyCardIntent.self, provider: MyCardProvider()) { entry in
            MyCardEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct MyCardWidget_Previews: PreviewProvider {
    static var previews: some View {
        MyCardEntryView(entry: MyCardEntry(date: Date(), configuration: MyCardIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
