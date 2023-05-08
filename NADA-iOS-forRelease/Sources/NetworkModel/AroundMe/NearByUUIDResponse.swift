//
//  NearByUUIDResponse.swift
//  NADA-iOS-forRelease
//
//  Created by Yi Joon Choi on 2023/05/02.
//

import Foundation

// MARK: - NearByUUIDResponse
struct NearByUUIDResponse: Codable {
    let activeTime, inactiveTime: String?
    let isActive: Bool
}
