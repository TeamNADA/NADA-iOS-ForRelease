//
//  UserWithTokenRequest.swift
//  NADA-iOS-forRelease
//
//  Created by 민 on 2021/11/13.
//

import Foundation

// MARK: - UserWithTokenRequest
struct UserWithTokenRequest: Codable {
    let user: UserData
}

// MARK: - User
struct UserData: Codable {
    let userID: String
    let token: Token

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case token
    }
}

// MARK: - Token
struct Token: Codable {
    let grantType, accessToken, refreshToken: String
    let accessTokenExpiresIn: Int
}
