//
//  AroundMeResponse.swift
//  NADA-iOS-forRelease
//
//  Created by Yi Joon Choi on 2023/03/12.
//

import Foundation

struct AroundMeResponse: Codable {
    let name, cardName: String
    let imageURL: String
    let cardUUID: String

    enum CodingKeys: String, CodingKey {
        case name, cardName
        case imageURL = "imageUrl"
        case cardUUID = "cardUuid"
    }
}
