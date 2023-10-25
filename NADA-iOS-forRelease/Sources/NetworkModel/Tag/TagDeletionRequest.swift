//
//  TagDeletionRequest.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2023/10/02.
//

import Foundation

public struct TagDeletionRequest: Codable {
    let cardTagID: Int
    
    enum CodingKeys: String, CodingKey {
        case cardTagID = "cardTagId"
    }
}
