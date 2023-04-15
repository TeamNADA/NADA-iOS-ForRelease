//
//  CardReorderInfo.swift
//  NADA-iOS-forRelease
//
//  Created by 민 on 2021/11/08.
//

import Foundation

// MARK: - CardReorderInfo
struct CardReorderInfo: Codable {
    let cardID: Int
    let isRepresentative: Bool
    let sortOrder: Int

    enum CodingKeys: String, CodingKey {
        case cardID = "cardId"
        case isRepresentative, sortOrder
    }
}

// MARK: - CardReorderInfos
struct CardReorderInfosRequest: Codable {
    let cardReorderInfos: [CardReorderInfo]
}
