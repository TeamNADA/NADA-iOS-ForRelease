//
//  CardListRequest.swift
//  NADA-iOS-forRelease
//
//  Created by 민 on 2021/11/08.
//

import Foundation

// MARK: - CardListRequest
struct CardListRequest: Codable {
    let cardDates: [CardList]
}

// MARK: - CardList
struct CardList: Codable {
    let cardID, title: String

    enum CodingKeys: String, CodingKey {
        case cardID = "cardId"
        case title
    }
}
