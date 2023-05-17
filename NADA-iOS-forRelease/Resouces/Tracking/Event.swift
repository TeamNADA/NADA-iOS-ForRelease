//
//  Event.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2023/05/18.
//

import Foundation

extension Tracking {
    struct Event {
        private init() { }
        static let touchOnboardingStart = "A2.온보딩_시작"
        static let touchKakaoLogin = "A3.로그인_카카오"
        static let touchAppleLogin = "A3.로그인_애플"
    }
}
