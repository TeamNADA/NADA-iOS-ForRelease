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
    
    // TODO: - 쓰게 될줄 알았는데 안써서 일단 보류
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        groups = (try? values.decode([Group].self, forKey: .groups)) ?? [Group]()
//    }
}

// MARK: - Group

struct Group: Codable {
    var groupID: Int
    var groupName: String
    
    enum CodingKeys: String, CodingKey {
        case groupID = "groupId"
        case groupName
    }
    // TODO: - 쓰게 될줄 알았는데 안써서 일단 보류
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        groupID = (try? values.decode(Int.self, forKey: .groupID)) ?? -1
//        groupName = (try? values.decode(String.self, forKey: .groupName)) ?? ""
//    }
}
