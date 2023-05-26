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
        static let main = "B1_메인탭"
        static let receiveCardBottomSheet = "B2_명함받기모달"
        static let cardResultBottomSheet = "B5_명함추가모달"
        static let selectGroupBottomSheet = "B6_그룹선택모달"
        static let aroundMe = "B7_내근처의명함"
        static let myCard = "C1 내 명함"
        static let cardShareBottomSheet = "C2 명함공유 모달"
        static let createCardCategory = "C3 명함만들기"
        static let createBasicCard = "C4 명함만들기_기본"
        static let createBasicCardPreview = "C5 명함만들기_기본_미리보기"
        static let createFanCard = "C6 명함만들기_덕질"
        static let createFanCardPreview = "C7 명함만들기_덕질_미리보기"
        static let createCompanyCard = "C8 명함만들기_직장"
        static let createCompanyCardPreview = "C9 명함만들기_직장_미리보기"
        static let cardList = "C10 명함리스트"
        static let cardGroupList = "D1_명함모음"
        static let editGroupList = "D2_그룹편집"
        static let cardDetail = "D3_명함상세"
        static let more = "E1 설정"
        static let myCardWidget = "F1 명함 위젯"
        static let qrcodeWidget = "F2 QR 위젯"
    }
}
