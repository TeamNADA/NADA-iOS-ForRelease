//
//  Users.swift
//  NADA-iOS-forRelease
//
//  Created by 민 on 2021/11/13.
//

import Foundation

// MARK: - User

struct User: Codable {
    let userID: String

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
    }
}
