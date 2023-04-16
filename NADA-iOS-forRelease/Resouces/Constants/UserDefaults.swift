//
//  UserDefaults.swift
//  NADA-iOS-forRelease
//
//  Created by 민 on 2021/12/07.
//

import Foundation

extension Const {
    struct UserDefaultsKey {
        static let darkModeState = "darkModeState"
        static let userID = "userID"
        static let isFirstCard = "isFirstCard"
        static let isOnboarding = "isOnboarding"
        static let firstCardID = "firstCardID"
        static let isAppleLogin = "isAppleLogin"
        static let isKakaoLogin = "isKakaoLogin"
        static let dynamicLinkCardUUID = "dynamicLinkCardUUID"
        // TODO: - KeyChain 적용
        static let accessToken = "accessToken"
        static let refreshToken = "refreshToken"
    }
}
