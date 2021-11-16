//
//  GroupListResponse.swift
//  NADA-iOS-forRelease
//
//  Created by Yi Joon Choi on 2021/11/06.
//

import Foundation

struct Groups: Codable {
    var groups: [Group]?
}

struct Group: Codable {
    var groupId: Int?
    var groupName: String?
}
