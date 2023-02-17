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
        MyCardEntry(date: Date(), widgetCard: WidgetCard(cardID: "", title: "일이삼사오육칠팔구", userName: "일이삼사오육", backgroundImage: UIImage()))
    }

    func getSnapshot(for configuration: MyCardIntent, in context: Context, completion: @escaping (MyCardEntry) -> Void) {
        let entry: MyCardEntry
        
        if let cardID = configuration.myCard?.identifier,
           let card = fetchMyCard(with: cardID) {
            entry = MyCardEntry(date: Date(), widgetCard: WidgetCard(cardID: card.cardID,
                                                       title: card.title,
                                                       userName: card.name,
            // TODO: - image 를 통신하거나 DB 에서 꺼내오는 작업이 필요하다.
                                                       backgroundImage: UIImage(named: card.background) ?? UIImage()))
        } else {
            entry = MyCardEntry(date: Date(), widgetCard: nil)
        }
        
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

extension MyCardProvider {
    // TODO: - 서버 혹은 DB 를 활용하여 내 명함을 조회하는 함수로 변경.
    private func fetchMyCard(with cardID: String) -> Card? {
        var matchedCard: Card?
        
        Card.mockData.forEach { card in
            if card.cardID == cardID {
                matchedCard = card
            }
        }
        
        return matchedCard
    }
}

struct WidgetCard {
    let cardID: String
    let title: String
    let userName: String
    let backgroundImage: UIImage
}

struct MyCardEntry: TimelineEntry {
    let date: Date
    let widgetCard: WidgetCard?
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
