//
//  CardCreation.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2021/11/04.
//

import Foundation

// MARK: - CardCreation
struct CardCreationRequest: Codable {
    let userID: String
    let frontCard: FrontCard
    let backCard: BackCard
    
    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case frontCard, backCard
    }
}

// MARK: - FrontCard

struct FrontCard: Codable {
    let defaultImage: Int
    let title, name, birthDate, mbti: String
    let instagram, linkName, link, description: String

    enum CodingKeys: String, CodingKey {
        case defaultImage, title, name, birthDate, mbti, instagram, linkName, link, description
    }
}
    
// MARK: - BackCard

struct BackCard: Codable {
    let isMincho, isSoju, isBoomuk, isSauced: Bool
    let oneQuestion, oneAnswer, twoQuestion, twoAnswer: String

    enum CodingKeys: String, CodingKey {
        case isMincho, isSoju, isBoomuk, isSauced, oneQuestion, oneAnswer, twoQuestion, twoAnswer
    }
}
