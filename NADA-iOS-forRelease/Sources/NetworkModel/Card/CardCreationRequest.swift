//
//  CardCreation.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2021/11/04.
//

import Foundation

// MARK: - CardCreationRequest

struct CardCreationRequest: Codable {
    let cardImageURL: String
    let cardType: String
    let frontCard: FrontCardDataModel
    let backCard: BackCardDataModel
}

// MARK: - FrontCardDataModel

struct FrontCardDataModel: Codable {
    let birth, cardName, userName: String
    
    let departmentName, mailAddress, mbti, phoneNumber, instagram, twitter: String?
    let urls: [String]?
    let defaultImageIndex: Int
}
    
// MARK: - BackCardDataModel

struct BackCardDataModel: Codable {
    let tastes: [String]
    let tmi: String?
}
