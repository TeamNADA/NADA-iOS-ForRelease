//
//  HarmonyResponse.swift
//  NADA-iOS-forRelease
//
//  Created by Yi Joon Choi on 2021/12/26.
//

import Foundation
import UIKit

import Lottie

// MARK: - HarmonyResponse
struct HarmonyResponse: Codable {
    let mbtiGrade: Int?
    let constellationGrade: Int
    let totalGrade: Int
    
    enum CodingKeys: String, CodingKey {
        case mbtiGrade
        case constellationGrade
        case totalGrade
    }
}

struct HarmonyData {
    let lottie: Int
    let mbtiGrade: Int
    let constellationGrade: Int
    let totalGrade: Int
    let color: UIColor
    let description: String
    let cardtype: String
}
