//
//  Card.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2021/11/04.
//

import Foundation

// MARK: - Card
struct Card: Codable {
    let cardID, background, title, name, birthDate, age, mbti: String
    let instagram, linkName, link, cardDescription: String?
    let isMincho, isSoju, isBoomuk, isSauced: Bool
    let oneQuestion, oneAnswer, twoQuestion, twoAnswer: String?

    enum CodingKeys: String, CodingKey {
        case cardID = "cardId"
        case background, title, name, birthDate, age, mbti, instagram, linkName, link, isMincho, isSoju, isBoomuk, isSauced, oneQuestion, oneAnswer, twoQuestion, twoAnswer
        case cardDescription = "description"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        cardID = (try? values.decode(String.self, forKey: .cardID)) ?? ""
        background = (try? values.decode(String.self, forKey: .background)) ?? ""
        title = (try? values.decode(String.self, forKey: .title)) ?? ""
        name = (try? values.decode(String.self, forKey: .name)) ?? ""
        birthDate = (try? values.decode(String.self, forKey: .birthDate)) ?? ""
        age = (try? values.decode(String.self, forKey: .age)) ?? ""
        mbti = (try? values.decode(String.self, forKey: .mbti)) ?? ""
        instagram = (try? values.decode(String.self, forKey: .instagram))
        linkName = (try? values.decode(String.self, forKey: .linkName))
        link = (try? values.decode(String.self, forKey: .link))
        cardDescription = (try? values.decode(String.self, forKey: .cardDescription))
        isMincho = (try? values.decode(Bool.self, forKey: .isMincho)) ?? false
        isSoju = (try? values.decode(Bool.self, forKey: .isSoju)) ?? false
        isBoomuk = (try? values.decode(Bool.self, forKey: .isBoomuk)) ?? false
        isSauced = (try? values.decode(Bool.self, forKey: .isSauced)) ?? false
        oneQuestion = (try? values.decode(String.self, forKey: .oneQuestion))
        oneAnswer = (try? values.decode(String.self, forKey: .oneAnswer))
        twoQuestion = (try? values.decode(String.self, forKey: .twoQuestion))
        twoAnswer = (try? values.decode(String.self, forKey: .twoAnswer))
    }
}
