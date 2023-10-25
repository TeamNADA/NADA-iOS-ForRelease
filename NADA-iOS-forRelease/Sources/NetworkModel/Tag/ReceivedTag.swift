//
//  ReceivedTag.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2023/09/25.
//

import Foundation

public struct ReceivedTag: Codable {
    let adjective: String
    let cardTagID: Int
    let db: Int
    let dg: Int
    let dr: Int
    let icon: String
    let noun: String
    let lb: Int
    let lg: Int
    let lr: Int
    
    enum CodingKeys: String, CodingKey {
        case adjective, icon, noun
        case cardTagID = "cardTagId"
        case db = "darkB"
        case dg = "darkG"
        case dr = "darkR"
        case lb = "whiteB"
        case lg = "whiteG"
        case lr = "whiteR"
    }
}
