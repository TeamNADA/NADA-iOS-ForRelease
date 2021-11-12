//
//  ChangeGroupRequest.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2021/11/08.
//

import Foundation

// MARK: - ChangeGroupRequest
struct ChangeGroupRequest: Codable {
    let cardID, userID: String
    let groupID, newGroupID: Int

    enum CodingKeys: String, CodingKey {
        case cardID = "cardId"
        case userID = "userId"
        case groupID = "groupId"
        case newGroupID = "newGroupId"
    }
}
