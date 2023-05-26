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
        static let splash = "A1_스플래시"
        static let onboarding = "A2_온보딩"
        static let login = "A3_로그인"
        static let myCard = "C1_내_명함"
        static let cardShareBottomSheet = "C2_명함공유_모달"
        static let createCardCategory = "C3_명함만들기"
        static let createBasicCard = "C4_명함만들기_기본"
        static let createBasicCardPreview = "C5_명함만들기_기본_미리보기"
        static let createFanCard = "C6_명함만들기_덕질"
        static let createFanCardPreview = "C7_명함만들기_덕질_미리보기"
        static let createCompanyCard = "C8_명함만들기_직장"
        static let createCompanyCardPreview = "C9_명함만들기_직장_미리보기"
        static let cardList = "C10_명함리스트"
        static let more = "E1_설정"
        static let myCardWidget = "F1_명함_위젯"
        static let qrcodeWidget = "F2_QR_위젯"
    }
}
