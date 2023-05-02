//
//  GroupListResponse.swift
//  NADA-iOS-forRelease
//
//  Created by Yi Joon Choi on 2021/11/06.
//

import Foundation

// MARK: - Groups

struct Groups: Codable {
    var groups: [Group]
    
    enum CondingKeys: String, CodingKey {
        case groups
    }
}

// MARK: - Group

struct Group: Codable {
    var cardGroupId: Int
    var cardGroupName: String
}
