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
    let cardID: String
    let author: String? = ""
    let background, title, name, birthDate, mbti: String
    let instagram, link, cardDescription, phoneNumber: String?
    let isMincho, isSoju, isBoomuk, isSauced: Bool
    let oneTmi, twoTmi, threeTmi: String?

    enum CodingKeys: String, CodingKey {
        case cardID = "cardId"
        case author, background, title, name, birthDate, mbti, instagram, link, phoneNumber
        case cardDescription = "description"
        case isMincho, isSoju, isBoomuk, isSauced, oneTmi, twoTmi, threeTmi
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
}
