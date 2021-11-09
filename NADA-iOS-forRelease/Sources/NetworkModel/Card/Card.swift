//
//  Card.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2021/11/04.
//

import Foundation

// MARK: - Card
struct Card: Codable {
    let cardID, background, title, name: String
    let birthDate, age, mbti, instagram: String
    let linkName, link, description: String
    let isMincho, isSoju, isBoomuk, isSauced: Bool
    let oneQuestion, oneAnswer, twoQuestion, twoAnswer: String

    enum CodingKeys: String, CodingKey {
        case cardID = "cardId"
        case background, title, name, birthDate, age, mbti, instagram, linkName, link, description
        case isMincho, isSoju, isBoomuk, isSauced, oneQuestion, oneAnswer, twoQuestion, twoAnswer
    }
}
