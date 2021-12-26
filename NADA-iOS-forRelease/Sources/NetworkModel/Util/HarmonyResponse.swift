//
//  HarmonyResponse.swift
//  NADA-iOS-forRelease
//
//  Created by Yi Joon Choi on 2021/12/26.
//

import Foundation
import UIKit

// MARK: - HarmonyResponse
struct HarmonyResponse: Codable {
    let harmony: Int
    
    enum CodingKeys: String, CodingKey {
        case harmony
    }
}

struct HarmonyData {
    let icon: String
    let percentage: String
    let color: UIColor
    let description: String
}
