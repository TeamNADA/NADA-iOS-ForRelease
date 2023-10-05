//
//  BannerResponse.swift
//  NADA-iOS-forRelease
//
//  Created by Yi Joon Choi on 2023/09/22.
//

import Foundation

// MARK: - Result
struct BannerResponse: Codable {
    let label, text, url: String
}
