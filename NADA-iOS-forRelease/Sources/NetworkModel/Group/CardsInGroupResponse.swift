//
//  CardsInGroupResponse.swift
//  NADA-iOS-forRelease
//
//  Created by Yi Joon Choi on 2021/11/16.
//

import Foundation

struct CardsInGroupResponse: Codable {
    let offset: Int
    let cards: [FrontCard]
    
    enum CodingKeys: String, CodingKey {
        case offset
        case cards
    }
}

// MARK: - Cards
struct FrontCard: Codable {
    let cardID: Int
    let cardUUID, cardType, cardName, departmentName: String
    let userName, birth, mbti, instagram: String
    let twitter, mailAddress: String?
    let phoneNumber: String
    let urls: [String]
    let cardTastes: [CardTaste]
    let tmi: String?
    let cardImage: String
    let isRepresentative: Bool

    enum CodingKeys: String, CodingKey {
        case cardID = "cardId"
        case cardUUID = "cardUuid"
        case cardType, cardName, departmentName, userName, birth, mbti, instagram, twitter, mailAddress, phoneNumber, urls, cardTastes, tmi, cardImage, isRepresentative
    }
}

// MARK: - CardTaste
struct CardTaste: Codable {
    let cardTasteName: String
    let sortOrder: Int
    let isChoose: Bool
}
