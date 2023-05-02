//
//  CardListInGroupRequest.swift
//  NADA-iOS-forRelease
//
//  Created by Yi Joon Choi on 2021/11/12.
//

import Foundation

struct CardListInGroupRequest: Codable {
    var pageNo: Int
    var pageSize: Int
    var groupName: String
}
