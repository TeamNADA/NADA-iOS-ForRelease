//
//  QRCodeWidget.swift
//  WidgetsExtension
//
//  Created by kimhyungyu on 2023/02/05.
//

import WidgetKit
import SwiftUI

struct QRCodeProvider: TimelineProvider {
    func placeholder(in context: Context) -> QRCodeEntry {
        QRCodeEntry(date: Date())
    }
    
    func getSnapshot(in context: Context, completion: @escaping (QRCodeEntry) -> Void) {
        let entry = QRCodeEntry(date: Date())
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        var entries: [QRCodeEntry] = []
        
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = QRCodeEntry(date: entryDate)
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .never)
        completion(timeline)
    }
}

struct QRCodeEntry: TimelineEntry {
    let date: Date
}

struct QRCodeEntryView: View {
    var entry: QRCodeProvider.Entry
    @Environment(\.widgetFamily) var widgetFamily
    
    var body: some View {
        if #available(iOSApplicationExtension 16.0, *) {
            switch widgetFamily {
            case .accessoryCircular:
                if #available(iOSApplicationExtension 17.0, *) {
                    ZStack {
                        Image("widgetQrLockscreenWhite")
                            .resizable()
                    }
                    .widgetURL(URL(string: "openQRCodeWidget"))
                    .containerBackground(for: .widget) {
                        AccessoryWidgetBackground()
                    }
                } else {
                    ZStack {
                        AccessoryWidgetBackground()
                        Image("widgetQrLockscreenWhite")
                            .resizable()
                            .widgetURL(URL(string: "openQRCodeWidget"))
                    }
                }
            default:
                if #available(iOSApplicationExtension 17.0, *) {
                    Image("widgetQr")
                        .resizable()
                        .scaledToFill()
                        .widgetURL(URL(string: "openQRCodeWidget"))
                        .containerBackground(for: .widget) { }
                } else {
                    Image("widgetQr")
                        .resizable()
                        .scaledToFill()
                        .widgetURL(URL(string: "openQRCodeWidget"))
                }
            }
        } else {
            Image("widgetQr")
                .resizable()
                .scaledToFill()
                .widgetURL(URL(string: "openQRCodeWidget"))
        }
    }
}

struct QRCodeWidget: Widget {
    private let supportedFamilies: [WidgetFamily] = {
        if #available(iOSApplicationExtension 16.0, *) {
            return [.systemSmall, .accessoryCircular]
        } else {
            return [.systemSmall]
        }
    }()
    
    let kind: String = "QRCodeWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind,
                            provider: QRCodeProvider()) { entry in
            QRCodeEntryView(entry: entry)
        }
        .configurationDisplayName("QR Code 위젯")
        .description("QR Code 를 인식할 수 있도록 카메라로 빠르게 접근합니다.")
        .supportedFamilies(supportedFamilies)
        .contentMarginsDisabled()
    }
}

struct QRCodeWidget_Previews: PreviewProvider {
    static var previews: some View {
        QRCodeEntryView(entry: QRCodeEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
        if #available(iOSApplicationExtension 16.0, *) {
            QRCodeEntryView(entry: QRCodeEntry(date: Date()))
                .previewContext(WidgetPreviewContext(family: .accessoryCircular))
        }
    }
}
