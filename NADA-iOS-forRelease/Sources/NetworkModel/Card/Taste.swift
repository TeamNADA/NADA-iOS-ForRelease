//
//  Taste.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2023/03/30.
//

import Foundation

struct Taste: Codable {
    let careType: CardType
    let tasteInfos: [TasteInfo]
}

enum CardType: String, Codable {
    case basic = "BASIC"
    case company = "COMPANY"
    case fan = "FAN"
}

struct TasteInfo: Codable {
    let sortOrder: Int
    let tasteName: String
}
