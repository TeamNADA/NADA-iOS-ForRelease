//
//  NearByRequest.swift
//  NADA-iOS-forRelease
//
//  Created by Yi Joon Choi on 2023/05/02.
//

import Foundation

// MARK: - NearByRequest
struct NearByRequest: Codable {
    let cardUUID: String
    let isActive: Bool
    let latitude, longitude: Double

    enum CodingKeys: String, CodingKey {
        case cardUUID = "cardUuid"
        case isActive, latitude, longitude
    }
}
