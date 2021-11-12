//
//  MainListRequest.swift
//  NADA-iOS-forRelease
//
//  Created by 민 on 2021/11/12.
//

import Foundation

// MARK: - MainList
struct MainListRequest: Codable {
    var userId: String
    var list: Bool
    var offset: Int
}
