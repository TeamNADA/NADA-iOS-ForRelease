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
    
    enum CodingKeys: String, CodingKey {
        case offset
        case cards
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        offset = (try? values.decode(Int.self, forKey: .offset)) ?? -1
        cards = (try? values.decode([Cards].self, forKey: .cards)) ?? [Cards]()
    }
}

// MARK: - Cards
struct Cards: Codable {
    let cardID, background, title, name, birthDate, age, mbti: String
    let instagram, linkName, link, cardDescription: String?

    enum CodingKeys: String, CodingKey {
        case cardID = "cardId"
        case background, title, name, birthDate, age, mbti, instagram, linkName, link
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
    }
} 
