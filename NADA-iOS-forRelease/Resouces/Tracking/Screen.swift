//
//  Screen.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2023/05/18.
//

import Foundation

extension Tracking {
    struct Screen {
        private init() { }
        static let splash = "A1 스플래시"
        static let onboarding = "A2 온보딩"
        static let login = "A3 로그인"
        static let myCard = "C1 내 명함"
        static let cardShareBottomSheet = "C2 명함공유 모달"
        static let createCardCategory = "C3 명함만들기"
        static let cardList = "C9 명함리스트"
        static let createBasicCard = "C4 명함만들기_기본"
        static let more = "E1 설정"
        static let myCardWidget = "F1 명함 위젯"
        static let qrcodeWidget = "F2 QR 위젯"
    }
}
