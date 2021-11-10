//
//  CardListEditRequest.swift
//  NADA-iOS-forRelease
//
//  Created by 민 on 2021/11/08.
//

import Foundation

// MARK: - CardListEdit
struct CardListEditRequest: Codable {
    let cardID: String
    let priority: Int

    enum CodingKeys: String, CodingKey {
        case cardID = "cardId"
        case priority
    }
}
