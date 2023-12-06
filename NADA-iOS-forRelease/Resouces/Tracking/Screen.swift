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
        static let receivedTag = "A4_홈_뒷면_받은태그"
        
        static let home = "B1_메인탭"
        static let receiveCardBottomSheet = "B2_명함받기모달"
        static let addByIdBottomSheet = "B3_ID로받기"
        static let addByQRBottomSheet = "B4_QR로받기"
        static let cardResultBottomSheet = "B5_명함추가모달"
        static let selectGroupBottomSheet = "B6_그룹선택모달"
        static let aroundMe = "B7_내근처의명함"
        
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
        
        static let cardGroupList = "D1_명함모음"
        static let editGroupList = "D2_그룹편집"
        static let cardDetail = "D3_명함상세"
        
        static let more = "E1_설정"
        static let myCardWidget = "F1_명함_위젯"
        static let qrcodeWidget = "F2_QR_위젯"
    }
}
