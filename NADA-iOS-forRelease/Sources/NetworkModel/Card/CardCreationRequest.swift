//
//  CardCreation.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2021/11/04.
//

import Foundation

// MARK: - CardCreation
struct CardCreationRequest: Codable {
    let frontCard: FrontCardDataModel
    let backCard: BackCardDataModel
}

// MARK: - FrontCard

struct FrontCardDataModel: Codable {
    let defaultImage: Int
    let title, name, birthDate, mbti: String
    let instagramID, linkURL, description: String
}
    
// MARK: - BackCard

struct BackCardDataModel: Codable {
    let isMincho, isSoju, isBoomuk, isSauced: Bool
    let firstTMI, secondTMI, thirdTMI: String
}
