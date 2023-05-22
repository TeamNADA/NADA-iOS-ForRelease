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
        static let touchOnboardingStart = "A2 온보딩_시작"
        static let touchKakaoLogin = "A3 로그인_카카오"
        static let touchAppleLogin = "A3 로그인_애플"
        static let touchCreateCard = "C1 내명함_추가"
        static let touchCardList = "C1 내명함_목록"
        static let scrollMyCard = "C1 내명함_imp_"
        static let touchCopyCardID = "C2 명함공유 모달_복사"
        static let touchSaveCardAsImage = "C2 명함공유 모달_저장"
        static let touchCardShareOn = "C2 명함공유 모달_내근처_ON"
        static let touchCardShareOff = "C2 명함공유 모달_내근처_OFF"
        static let touchCreateCardCategoryBack = "C3 명함만들기_뒤로가기"
        static let touchBasicCategory = "C3 명함만들기_기본"
        static let touchFanCategory = "C3 명함만들기_덕질"
        static let touchCompanyCategory = "C3 명함만들기_직장"
        static let touchCardListPin = "C9 명함리스트_핀"
        static let touchDarkmode = "E1 설정_다크모드"
        static let touchPrivacyPolicy = "E1 설정_개인정보"
        static let touchTermsOfUse = "E1 설정_이용약관"
        static let touchTeamNADA = "E1 설정_팀나다"
        static let touchOpenSource = "E1 설정_오픈소스"
        static let touchLogout = "E1 설정_로그아웃"
        static let touchReset = "E1 설정_초기화"
        static let touchDelete = "E1 설정_탈퇴"
        static let changeMyCard = "F1 명함위젯_명함바꾸기"
    }
}
