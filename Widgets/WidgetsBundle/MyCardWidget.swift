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
        MyCardEntry(date: Date(), widgetCard: WidgetCard(cardUUID: "", title: "일이삼사오육칠팔구", userName: "일이삼사오육", backgroundImage: UIImage()))
    }

    func getSnapshot(for configuration: MyCardIntent, in context: Context, completion: @escaping (MyCardEntry) -> Void) {
        if let myCard = configuration.myCard {
            completion(MyCardEntry(date: Date(), widgetCard: WidgetCard(cardUUID: myCard.identifier ?? "",
                                                                        title: myCard.displayString,
                                                                        userName: myCard.userName ?? "",
                                                                        backgroundImage: fetchImage(myCard.cardImage ?? ""))))
        } else {
            completion(MyCardEntry(date: Date(), widgetCard: nil))
        }
    }

    func getTimeline(for configuration: MyCardIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        var entries: [MyCardEntry] = []

        let currentDate = Date()
        let entryDate = Calendar.current.date(byAdding: .second, value: 5, to: currentDate) ?? Date()
        
        if let card = configuration.myCard {
            cardListFetchWithAPI { result in
                switch result {
                case .success(let response):
                    if let data = response?.data {
                        if data.contains(where: { cardDataModel in
                            return cardDataModel.cardUUID == card.identifier
                        }) {
                            // 명함이 있음
                            let entry = MyCardEntry(date: entryDate,
                                                    widgetCard: WidgetCard(cardUUID: card.identifier ?? "",
                                                                           title: card.displayString,
                                                                           userName: card.userName ?? "",
                                                                           backgroundImage: fetchImage(card.cardImage ?? "")))
                            entries = [entry]
                            let timeline = Timeline(entries: entries, policy: .atEnd)
                            completion(timeline)
                        } else {
                            if data.isEmpty {
                                // 대표 명함이 없음.
                                let entry = MyCardEntry(date: entryDate, widgetCard: nil)
                                entries = [entry]
                                let timeline = Timeline(entries: entries, policy: .atEnd)
                                completion(timeline)

                            } else {
                                // 해당 명함이 삭제되어 없음. -> 대표 명함(첫 번째 명함)을 보여주도록 함
                                let entry = MyCardEntry(date: entryDate,
                                                       widgetCard: WidgetCard(cardUUID: data[0].cardUUID,
                                                                               title: data[0].cardName,
                                                                               userName: data[0].userName,
                                                                               backgroundImage: fetchImage(data[0].cardImage)))
                                entries = [entry]
                                let timeline = Timeline(entries: entries, policy: .atEnd)
                                completion(timeline)
                            }
                        }
                    }
                case .failure(let error):
                    print(error)
                    // 회원 탈퇴, 로그아웃
                    let entry = MyCardEntry(date: entryDate, widgetCard: nil)
                    entries = [entry]
                    let timeline = Timeline(entries: entries, policy: .atEnd)
                    completion(timeline)
                }
            }
        } else {
            // Configuration 로 부터 card 받지 못함.(=로그인 전 위젯 생성 시)
            print("Configuration")
            let entry = MyCardEntry(date: entryDate, widgetCard: nil)
            entries = [entry]
            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        }
    }
}

// MARK: - Network

extension MyCardProvider {
    private func fetchImage(_ urlString: String) -> UIImage {
        guard let url = URL(string: urlString),
              let data = try? Data(contentsOf: url),
              let image = UIImage(data: data) else { return UIImage() }
        
        return image
    }
    
    enum WidgetError: Error {
        case networkFail(status: Int, code: String, message: String)
        case decodeFail(status: Int)
        case error(status: Int, error: Error)
    }
    
    func cardListFetchWithAPI(completion: @escaping (Result<GenericResponse<[Card]>?, Error>) -> Void) {
        guard let url = URL(string: Const.URL.baseURL + "/v1/card") else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("Bearer \(UserDefaults.appGroup.string(forKey: "AccessToken") ?? "")", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let status = (response as? HTTPURLResponse)?.statusCode else { return }
            
            if let error = error {
                completion(.failure(WidgetError.error(status: status, error: error)))
            } else {
                if let data {
                    let result = try? JSONDecoder().decode(GenericResponse<[Card]>.self, from: data)
                    
                    if status != 200 {
                        completion(.failure(WidgetError.networkFail(status: status,
                                                                    code: result?.code ?? "none code",
                                                                    message: result?.message ?? "none message")))
                    } else {
                        if let result {
                            if result.status != 200 {
                                completion(.failure(WidgetError.networkFail(status: result.status,
                                                                            code: result.code ?? "none code",
                                                                            message: result.message ?? "none message")))
                            } else {
                                completion(.success(result))
                            }
                        } else {
                            completion(.failure(WidgetError.decodeFail(status: status)))
                        }
                    }
                }
            }
        }.resume()
    }
}

struct WidgetCard {
    let cardUUID: String
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
struct EmptyMyCardView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            Color.widgetBackgrounColor(for: colorScheme)
            VStack(spacing: 4) {
                Text("아직 내 명함이 없어요😥")
                    .font(.textRegular05)
                    .foregroundColor(.primaryColor(for: colorScheme))
                HStack {
                    Text("명함 만들러 가기")
                        .font(.textRegular05)
                        .foregroundColor(.primaryColor(for: colorScheme))
                    Image("icnArrowForwardIos")
                }
            }
        }
    }
}

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
                            .font(.cardName)
                            .foregroundColor(.init(white: 1.0))
                            .padding(EdgeInsets(top: 12, leading: 10, bottom: 0, trailing: 0))
                            .lineLimit(1)
                        Spacer()
                        Image("logoNada")
                            .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 10))
                    }
                    Spacer()
                    HStack {
                        Spacer()
                        Text(widgetCard.userName)
                            .font(.userName)
                            .foregroundColor(.userNameColor(for: colorScheme))
                            .padding(EdgeInsets(top: 0, leading: 10, bottom: 11, trailing: 10))
                            .lineLimit(1)
                    }
                }
            }
            .widgetURL(URL(string: "openMyCardWidget://?cardUUID=\(widgetCard.cardUUID)"))
        } else {
            Image("widgetEmpty")
                .resizable()
                .scaledToFill()
            if #available(iOSApplicationExtension 17.0, *) {
                EmptyMyCardView()
                .containerBackground(for: .widget) {
                    Color.widgetBackgrounColor(for: colorScheme)
                }
            } else {
                EmptyMyCardView()
            }
        }
    }
}

struct MyCardWidget: Widget {
    let kind: String = "MyCardWidget"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind,
                            intent: MyCardIntent.self,
                            provider: MyCardProvider()) { entry in
            MyCardEntryView(entry: entry)
        }
        .configurationDisplayName("명함 위젯")
        .description("명함 이미지를 보여주고,\n내 명함으로 빠르게 접근합니다.")
        .supportedFamilies([.systemSmall])
        .contentMarginsDisabled()
    }
}

struct MyCardWidget_Previews: PreviewProvider {
    static var previews: some View {
        MyCardEntryView(entry: MyCardEntry(date: Date(), widgetCard: nil))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
        MyCardEntryView(entry: MyCardEntry(date: Date(), widgetCard: WidgetCard(cardUUID: Card.mockData[0].cardUUID, title: Card.mockData[0].cardName, userName: Card.mockData[0].userName, backgroundImage: UIImage(named: Card.mockData[0].cardImage) ?? UIImage())))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
