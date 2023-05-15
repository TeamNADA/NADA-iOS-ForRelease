//
//  UserLoginRequest.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2023/05/15.
//

import Foundation

struct UserLoginRequest: Codable {
    let socialID: String
    let socialType: String
    let fcmToken: String
    
    enum CodingKeys: String, CodingKey {
        case socialID = "socialId"
        case socialType
        case fcmToken
    }
}
