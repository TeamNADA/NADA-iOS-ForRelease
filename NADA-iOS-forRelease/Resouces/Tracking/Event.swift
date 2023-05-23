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
        static let touchOnboardingStart = "A2_온보딩_시작"
        
        static let touchKakaoLogin = "A3_로그인_카카오"
        static let touchAppleLogin = "A3_로그인_애플"
        
        static let touchCreateCard = "C1_내명함_추가"
        static let touchCardList = "C1_내명함_목록"
        static let scrollMyCard = "C1_내명함_imp_"
        static let touchBasicCardShare = "C1_내명함_기본_공유"
        static let touchBasicCardSNS = "C1_내명함_기본_SNS"
        static let touchBasicCardURL = "C1_내명함_기본_url"
        static let touchFanCardShare = "C1_내명함_덕질_공유"
        static let touchFanCardSNS = "C1_내명함_덕질_SNS"
        static let touchFanCardURL1 = "C1_내명함_덕질_url_1"
        static let touchFanCardURL2 = "C1_내명함_덕질_url_2"
        static let touchCompanyCardShare = "C1_내명함_직장_공유"
        static let touchCompanyCardURL = "C1_내명함_직장_url"
        
        static let touchCopyCardID = "C2_명함공유 모달_복사"
        static let touchSaveCardAsImage = "C2_명함공유_모달_저장"
        static let touchCardShareOn = "C2_명함공유_모달_내근처_ON"
        static let touchCardShareOff = "C2_명함공유_모달_내근처_OFF"
        
        static let touchCreateCardCategoryBack = "C3_명함만들기_뒤로가기"
        static let touchBasicCategory = "C3_명함만들기_기본"
        static let touchFanCategory = "C3_명함만들기_덕질"
        static let touchCompanyCategory = "C3_명함만들기_직장"
        
        static let touchExitCreateBasicCard = "C4_명함만들기_기본_종료"
        static let touchFrontCreateBasicCard = "C4_명함만들기_기본_앞면"
        static let touchBackCreateBasicCard = "C4_명함만들기_기본_뒷면"
        static let touchBasicCameraImage = "C4_명함만들기_기본_사진"
        static let touchBasicDefaultImage = "C4_명함만들기_기본_이미지"
        static let touchBasicTasteInfo = "C4_명함만들기_기본_"
        static let touchBasicCardPreview = "C4_명함만들기_기본_미리보기"
        
        static let touchBackFromBasicPreview = "C5_명함만들기_기본_미리보기_뒤로가기"
        static let touchPreviewBasicComplete = "C5_명함만들기_기본_미리보기_완료"
        
        static let touchExitCreateFanCard = "C6_명함만들기_덕질_종료"
        static let touchFrontCreateFanCard = "C6_명함만들기_덕질_앞면"
        static let touchBackCreateFanCard = "C6_명함만들기_덕질_뒷면"
        static let touchFanCameraImage = "C6_명함만들기_덕질_사진"
        static let touchFanDefaultImage = "C6_명함만들기_덕질_이미지"
        static let touchFanTasteInfo = "C6_명함만들기_덕질_"
        static let touchFanCardPreview = "C6_명함만들기_덕질_미리보기"
        
        static let touchBackFromFanPreview = "C7_명함만들기_덕질_미리보기_뒤로가기"
        static let touchPreviewFanComplete = "C7_명함만들기_덕질_미리보기_완료"
        
        static let touchExitCreateCompanyCard = "C8_명함만들기_직장_종료"
        static let touchFrontCreateCompanyCard = "C8_명함만들기_직장_앞면"
        static let touchBackCreateCompanyCard = "C8_명함만들기_직장_뒷면"
        static let touchCompanyCameraImage = "C8_명함만들기_직장_사진"
        static let touchCompanyDefaultImage = "C8_명함만들기_직장_이미지"
        static let touchCompanyTasteInfo = "C8_명함만들기_직장"
        static let touchCompanyCardPreview = "C8_명함만들기_직장_미리보기"
        
        static let touchBackFromCompanyPreview = "C9_명함만들기_직장_미리보기_뒤로가기"
        static let touchPreviewCompanyComplete = "C9_명함만들기_직장_미리보기_완료"
        
        static let touchCardListPin = "C10_명함리스트_핀"
        
        static let touchDarkmode = "E1_설정_다크모드"
        static let touchPrivacyPolicy = "E1_설정_개인정보"
        static let touchTermsOfUse = "E1_설정_이용약관"
        static let touchTeamNADA = "E1_설정_팀나다"
        static let touchOpenSource = "E1_설정_오픈소스"
        static let touchLogout = "E1_설정_로그아웃"
        static let touchReset = "E1_설정_초기화"
        static let touchDelete = "E1_설정_탈퇴"
        
        static let changeMyCard = "F1_명함위젯_명함바꾸기"
    }
}
