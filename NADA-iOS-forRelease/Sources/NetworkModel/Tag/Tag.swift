//
//  Tag.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2023/09/26.
//

import Foundation

public struct Tag: Codable {
    let db: Int
    let dg: Int
    let dr: Int
    let icon: String
    let lb: Int
    let lg: Int
    let lr: Int
    
    enum CodingKeys: String, CodingKey {
        case db = "darkB"
        case dg = "darkG"
        case dr = "darkR"
        case icon
        case lb = "whiteB"
        case lg = "whiteG"
        case lr = "whiteR"
    }
}
