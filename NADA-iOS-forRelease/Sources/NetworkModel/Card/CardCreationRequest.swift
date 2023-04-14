//
//  CardCreation.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2021/11/04.
//

import Foundation

// MARK: - CardCreation
struct CardCreationRequest: Codable {
    let cardImageURL: String
    let cardType: String
    let frontCard: FrontCardDataModel
    let backCard: BackCardDataModel
}

// MARK: - FrontCard
struct FrontCardDataModel: Codable {
    let birth, cardName, userName: String
    
    let departmentName, mailAddress, mbti, phoneNumber, sns: String?
    let urls: [String]?
    let defaultImageIndex: Int
}
    
// MARK: - BackCard
struct BackCardDataModel: Codable {
    let tastes: [String]
    let tmi: String?
}
