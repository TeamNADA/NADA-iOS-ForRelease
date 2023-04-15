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
    let birth: String
        let cardID: Int
        let cardImage, cardName, cardType, cardUUID: String
        let departmentName, instagram, mailAddress, mbti: String
        let phoneNumber, tmi, twitter, urls: String
        let userName: String

        enum CodingKeys: String, CodingKey {
            case birth
            case cardID = "cardId"
            case cardImage, cardName, cardType
            case cardUUID = "cardUuid"
            case departmentName, instagram, mailAddress, mbti, phoneNumber, tmi, twitter, urls, userName
        }
} 
