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
        static let isOnboarding = "isOnboardingAvailable"
        static let firstCardID = "firstCardID"
        static let isAppleLogin = "isAppleLogin"
        static let isKakaoLogin = "isKakaoLogin"
        static let dynamicLinkCardUUID = "dynamicLinkCardUUID"
        static let accessToken = "AccessToken"
        static let openQRCodeWidget = "openQRCodeWidget"
        static let openMyCardWidget = "openMyCardWidget"
        static let widgetCardUUID = "widgetCardUUID"
        static let refreshToken = "refreshToken"
        static let fcmToken = "fcmToken"
    }
}
