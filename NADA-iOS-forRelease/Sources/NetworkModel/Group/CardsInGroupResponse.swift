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
    let cardID, background, title, name, birthDate, mbti: String
    let instagram, link, cardDescription: String?
    
    enum CodingKeys: String, CodingKey {
        case cardID = "cardId"
        case background, title, name, birthDate, mbti, instagram, link
        case cardDescription = "description"
    }
} 
