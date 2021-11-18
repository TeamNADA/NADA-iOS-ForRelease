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
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        groups = (try? values.decode([Group].self, forKey: .groups)) ?? [Group]()
    }
}

// MARK: - Group

struct Group: Codable {
    var groupID: Int
    var groupName: String
    
    enum CodingKeys: String, CodingKey {
        case groupID = "groupId"
        case groupName
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        groupID = (try? values.decode(Int.self, forKey: .groupID)) ?? -1
        groupName = (try? values.decode(String.self, forKey: .groupName)) ?? ""
    }
}
