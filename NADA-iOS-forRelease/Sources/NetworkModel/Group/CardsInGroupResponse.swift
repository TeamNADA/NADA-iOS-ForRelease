//
//  CardsInGroupResponse.swift
//  NADA-iOS-forRelease
//
//  Created by Yi Joon Choi on 2021/11/16.
//

import Foundation

struct CardsInGroupResponse: Codable {
    let offset: Int
    let cards: [Cards]
}

// MARK: - Cards
struct Cards: Codable {
    let cardID, background, title, name: String
    let birthDate, age, mbti, instagram: String
    let linkName, link, cardDescription: String

    enum CodingKeys: String, CodingKey {
        case cardID = "cardId"
        case background, title, name, birthDate, age, mbti, instagram, linkName, link
        case cardDescription = "description"
    }
} 
