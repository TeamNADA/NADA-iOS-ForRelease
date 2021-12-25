//
//  Card.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2021/11/04.
//

import Foundation

// MARK: - DataClass
struct CardClass: Codable {
    let card: Card
}

// MARK: - Card
struct Card: Codable {
    let cardID, background, title, name: String
    let birthDate, mbti, instagram, link: String
    let cardDescription: String
    let isMincho, isSoju, isBoomuk, isSauced: Bool
    let oneTmi, twoTmi, threeTmi: String

    enum CodingKeys: String, CodingKey {
        case cardID = "cardId"
        case background, title, name, birthDate, mbti, instagram, link
        case cardDescription = "description"
        case isMincho, isSoju, isBoomuk, isSauced, oneTmi, twoTmi, threeTmi
    }
}
    // FIXME: - 메인에서 카드 정보 정적으로 생성하기 위한 주석
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
//        oneTMI = (try? values.decode(String.self, forKey: .oneTMI))
//        twoTMI = (try? values.decode(String.self, forKey: .twoTMI))
//        thirdTMI = (try? values.decode(String.self, forKey: .thirdTMI))
//    }
//}
