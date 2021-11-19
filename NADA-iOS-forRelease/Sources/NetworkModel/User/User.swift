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
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        userID = (try? values.decode(String.self, forKey: .userID)) ?? ""
    }
}
