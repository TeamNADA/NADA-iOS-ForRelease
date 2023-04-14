//
//  CardListInGroupRequest.swift
//  NADA-iOS-forRelease
//
//  Created by Yi Joon Choi on 2021/11/12.
//

import Foundation

struct CardListInGroupRequest: Codable {
    var userId: String
    var groupId: Int
    var offset: Int
}
