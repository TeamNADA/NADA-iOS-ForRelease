//
//  CreateTagRequest.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2023/09/26.
//

import Foundation

struct CreationTagRequest: Codable {
    let adjective: String
    let cardUUID: String
    let icon: String
    let noun: String
    
    enum CodingKeys: String, CodingKey {
        case cardUUID = "cardUuid"
        case adjective, icon, noun
    }
}
