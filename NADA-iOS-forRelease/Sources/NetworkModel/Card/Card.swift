//
//  Card.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2021/11/04.
//

import Foundation

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
    let instagram: String?
    let twitter: String?
    let tmi: String?
    let urls: [String]?
    let userName: String

    enum CodingKeys: String, CodingKey {
        case birth, cardImage, cardName, cardTastes, cardType, departmentName, isRepresentative, mailAddress, mbti, phoneNumber, instagram, twitter, tmi, urls, userName
        case cardID = "cardId"
        case cardUUID = "cardUuid"
    }
    
    static let mockData = [
        Card(birth: "", cardID: 0, cardUUID: "id1", cardImage: "imgCardBg01", cardName: "첫 번째 카드", cardTastes: [CardTasteInfo(cardTasteName: "", isChoose: false, sortOrder: 0)], cardType: "", departmentName: "", isRepresentative: false, mailAddress: "", mbti: "", phoneNumber: "", instagram: "", twitter: "", tmi: "", urls: [], userName: "1현규"),
        Card(birth: "", cardID: 1, cardUUID: "id2", cardImage: "imgCardBg02", cardName: "두 번째 카드", cardTastes: [CardTasteInfo(cardTasteName: "", isChoose: false, sortOrder: 0)], cardType: "", departmentName: "", isRepresentative: false, mailAddress: "", mbti: "", phoneNumber: "", instagram: "", twitter: "", tmi: "", urls: [], userName: "2현규"),
        Card(birth: "", cardID: 2, cardUUID: "id3", cardImage: "imgCardBg03", cardName: "세 번째 카드", cardTastes: [CardTasteInfo(cardTasteName: "", isChoose: false, sortOrder: 0)], cardType: "", departmentName: "", isRepresentative: false, mailAddress: "", mbti: "", phoneNumber: "", instagram: "", twitter: "", tmi: "", urls: [], userName: "3현규")
    ]
}

// MARK: - CardTasteInfo

struct CardTasteInfo: Codable {
    let cardTasteName: String
    let isChoose: Bool
    let sortOrder: Int
    
    enum CodingKeys: String, CodingKey {
        case cardTasteName, isChoose, sortOrder
    }
}
