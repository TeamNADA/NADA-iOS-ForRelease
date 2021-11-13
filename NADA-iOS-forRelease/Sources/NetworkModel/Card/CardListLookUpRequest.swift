//
//  CardListLookUpRequest.swift
//  NADA-iOS-forRelease
//
//  Created by 민 on 2021/11/13.
//

import Foundation

// MARK: - CardListLookUpRequest
struct CardListLookUpRequest: Codable {
    let offset: Int
    let cards: [Card]
}

