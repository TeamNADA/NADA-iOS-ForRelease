//
//  CardAddInGroupRequest.swift
//  NADA-iOS-forRelease
//
//  Created by Yi Joon Choi on 2021/11/12.
//

import Foundation

struct CardAddInGroupRequest: Codable {
    var cardId: String?
    var userId: String?
    var groupId: Int?
}
