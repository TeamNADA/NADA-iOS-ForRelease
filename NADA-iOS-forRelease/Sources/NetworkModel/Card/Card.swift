//
//  Card.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2021/11/04.
//

import Foundation

// MARK: - CardClass
struct CardClass: Codable {
    let card: Card
}

// MARK: - Card
struct Card: Codable {
    let birth: String
    let cardID: Int
    let cardUUID: String
    let cardImage: String
    let cardName: String
    let cardTastes: [CardTasteInfo]
    let cardType: String
    let departmentName: String?
    let isRepresentative: Bool
    let mailAddress: String?
    let mbti: String?
    let phoneNumber: String?
    let sns: String?
    let tmi: String?
    let urls: [String]?
    let userName: String

    enum CodingKeys: String, CodingKey {
        case birth, cardImage, cardName, cardTastes, cardType, departmentName, isRepresentative, mailAddress, mbti, phoneNumber, sns, tmi, urls, userName
        case cardID = "cardId"
        case cardUUID = "cardUuid"
    }
        
    // TODO: - 쓰게 될줄 알았는데 안써서 일단 보류
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        cardID = (try? values.decode(String.self, forKey: .cardID)) ?? ""
//        background = (try? values.decode(String.self, forKey: .background)) ?? ""
//        title = (try? values.decode(String.self, forKey: .title)) ?? ""
//        name = (try? values.decode(String.self, forKey: .name)) ?? ""
//        birthDate = (try? values.decode(String.self, forKey: .birthDate)) ?? ""
//        mbti = (try? values.decode(String.self, forKey: .mbti)) ?? ""
//        instagram = (try? values.decode(String.self, forKey: .instagram))
//        link = (try? values.decode(String.self, forKey: .link))
//        cardDescription = (try? values.decode(String.self, forKey: .cardDescription))
//        isMincho = (try? values.decode(Bool.self, forKey: .isMincho)) ?? false
//        isSoju = (try? values.decode(Bool.self, forKey: .isSoju)) ?? false
//        isBoomuk = (try? values.decode(Bool.self, forKey: .isBoomuk)) ?? false
//        isSauced = (try? values.decode(Bool.self, forKey: .isSauced)) ?? false
//        oneTmi = (try? values.decode(String.self, forKey: .oneTmi))
//        twoTmi = (try? values.decode(String.self, forKey: .twoTmi))
//        threeTmi = (try? values.decode(String.self, forKey: .threeTmi))
//    }
    
    static let mockData = [
        Card(birth: "", cardID: 0, cardUUID: "id1", cardImage: "imgCardBg01", cardName: "첫 번째 카드", cardTastes: [CardTasteInfo(cardTasteName: "", isChoose: false, sortOrder: 0)], cardType: "", departmentName: "", isRepresentative: false, mailAddress: "", mbti: "", phoneNumber: "", sns: "", tmi: "", urls: [], userName: "1현규"),
        Card(birth: "", cardID: 1, cardUUID: "id2", cardImage: "imgCardBg02", cardName: "두 번째 카드", cardTastes: [CardTasteInfo(cardTasteName: "", isChoose: false, sortOrder: 0)], cardType: "", departmentName: "", isRepresentative: false, mailAddress: "", mbti: "", phoneNumber: "", sns: "", tmi: "", urls: [], userName: "2현규"),
        Card(birth: "", cardID: 2, cardUUID: "id3", cardImage: "imgCardBg03", cardName: "세 번째 카드", cardTastes: [CardTasteInfo(cardTasteName: "", isChoose: false, sortOrder: 0)], cardType: "", departmentName: "", isRepresentative: false, mailAddress: "", mbti: "", phoneNumber: "", sns: "", tmi: "", urls: [], userName: "3현규")
    ]
}

struct CardTasteInfo: Codable {
    let cardTasteName: String
    let isChoose: Bool
    let sortOrder: Int
    
    enum CodingKeys: String, CodingKey {
        case cardTasteName, isChoose, sortOrder
    }
}
