//
//  CardListLookUp.swift
//  NADA-iOS-forRelease
//
//  Created by 민 on 2021/12/27.
//

import Foundation

// MARK: - CardListLookUp
struct CardListLookUp: Codable {
    let offset: Int
    let cards: [Card]
}
