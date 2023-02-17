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

        let currentDate = Date()
        
        if let cardID = configuration.myCard?.identifier,
           let card = fetchMyCard(with: cardID) {
            for hourOffset in 0 ..< 5 {
                let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate) ?? Date()
                let entry = MyCardEntry(date: entryDate, widgetCard: WidgetCard(cardID: card.cardID,
                                                               title: card.title,
                                                               userName: card.name,
                // TODO: - image 를 통신하거나 DB 에서 꺼내오는 작업이 필요하다.
                                                               backgroundImage: UIImage(named: card.background) ?? UIImage()))
                entries.append(entry)
            }
        } else {
            for hourOffset in 0 ..< 5 {
                let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate) ?? Date()
                entries.append(MyCardEntry(date: entryDate, widgetCard: nil))
            }
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

    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        if let widgetCard = entry.widgetCard {
            ZStack {
                Color.white
                GeometryReader { proxy in
                    HStack(spacing: 0) {
                        Image(uiImage: widgetCard.backgroundImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: proxy.size.height * (92 / 152), height: proxy.size.height)
                            .clipped()
                        Color.backgroundColor(for: colorScheme)
                    }
                }
                VStack {
                    HStack {
                        Text(widgetCard.title)
                            .font(.system(size: 15))
                            .foregroundColor(.init(white: 1.0, opacity: 0.8))
                            .padding(EdgeInsets(top: 12, leading: 10, bottom: 0, trailing: 0))
                            .lineLimit(1)
                        Spacer()
                        Image("logoNada")
                            .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 10))
                    }
                    Spacer()
                    HStack {
                        Spacer()
                        Text(widgetCard.userName)
                            .font(.system(size: 15))
                            .foregroundColor(.userNameColor(for: colorScheme))
                            .padding(EdgeInsets(top: 0, leading: 10, bottom: 11, trailing: 10))
                            .lineLimit(1)
                    }
                }
            }
            .widgetURL(URL(string: "openMyCardWidget"))
        } else {
            Image("widgetEmpty")
                .resizable()
                .scaledToFill()
        }
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
