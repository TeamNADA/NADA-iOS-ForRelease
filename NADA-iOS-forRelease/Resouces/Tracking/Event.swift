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
        
        static let touchGiveCard = "B1_메인탭_명함주기"
        static let touchTakeCard = "B1_메인탭_명함받기"
        static let touchAroundMe = "B1_메인탭_내근처의명함"
        
        static let touchAddByID = "B2 명함받기모달_ID로받기"
        static let touchAddByQR = "B2_명함받기모달_QR로받기"
        
        static let touchAddCard = "B5_명함받기모달_추가"
        
        static let touchSelectGroup = "B6_그룹선택모달_완료"
        
        static let touchAroundMeClose = "B7_내근처의명함_닫기"
        static let touchAroundMeRefresh = "B7_내근처의명함_새로고침"
        static let touchAroundMeAdd = "B7_내근처의명함_추가"
        
        static let touchCreateCard = "C1 내명함_추가"
        static let touchCardList = "C1 내명함_목록"
        static let scrollMyCard = "C1 내명함_imp_"
        static let touchBasicCardShare = "C1 내명함_기본_공유"
        static let touchBasicCardSNS = "C1 내명함_기본_SNS"
        static let touchBasicCardURL = "C1 내명함_기본_url"
        static let touchFanCardShare = "C1 내명함_덕질_공유"
        static let touchFanCardSNS = "C1 내명함_덕질_SNS"
        static let touchFanCardURL1 = "C1 내명함_덕질_url_1"
        static let touchFanCardURL2 = "C1 내명함_덕질_url_2"
        static let touchCompanyCardShare = "C1 내명함_직장_공유"
        static let touchCompanyCardURL = "C1 내명함_직장_url"
        
        static let touchCopyCardID = "C2 명함공유 모달_복사"
        static let touchSaveCardAsImage = "C2 명함공유 모달_저장"
        static let touchCardShareOn = "C2 명함공유 모달_내근처_ON"
        static let touchCardShareOff = "C2 명함공유 모달_내근처_OFF"
        
        static let touchCreateCardCategoryBack = "C3 명함만들기_뒤로가기"
        static let touchBasicCategory = "C3 명함만들기_기본"
        static let touchFanCategory = "C3 명함만들기_덕질"
        static let touchCompanyCategory = "C3 명함만들기_직장"
        
        static let touchExitCreateBasicCard = "C4 명함만들기_기본_종료"
        static let touchFrontCreateBasicCard = "C4 명함만들기_기본_앞면"
        static let touchBackCreateBasicCard = "C4 명함만들기_기본_뒷면"
        static let touchBasicCameraImage = "C4 명함만들기_기본_사진"
        static let touchBasicDefaultImage = "C4 명함만들기_기본_이미지"
        static let touchBasicTasteInfo = "C4 명함만들기_기본_"
        static let touchBasicCardPreview = "C4 명함만들기_기본_미리보기"
        
        static let touchBackFromBasicPreview = "C5 명함만들기_기본_미리보기_뒤로가기"
        static let touchPreviewBasicComplete = "C5 명함만들기_기본_미리보기_완료"
        
        static let touchExitCreateFanCard = "C6 명함만들기_덕질_종료"
        static let touchFrontCreateFanCard = "C6 명함만들기_덕질_앞면"
        static let touchBackCreateFanCard = "C6 명함만들기_덕질_뒷면"
        static let touchFanCameraImage = "C6 명함만들기_덕질_사진"
        static let touchFanDefaultImage = "C6 명함만들기_덕질_이미지"
        static let touchFanTasteInfo = "C6 명함만들기_덕질_"
        static let touchFanCardPreview = "C6 명함만들기_덕질_미리보기"
        
        static let touchBackFromFanPreview = "C7 명함만들기_덕질_미리보기_뒤로가기"
        static let touchPreviewFanComplete = "C7 명함만들기_덕질_미리보기_완료"
        
        static let touchExitCreateCompanyCard = "C8 명함만들기_직장_종료"
        static let touchFrontCreateCompanyCard = "C8 명함만들기_직장_앞면"
        static let touchBackCreateCompanyCard = "C8 명함만들기_직장_뒷면"
        static let touchCompanyCameraImage = "C8 명함만들기_직장_사진"
        static let touchCompanyDefaultImage = "C8 명함만들기_직장_이미지"
        static let touchCompanyTasteInfo = "C8 명함만들기_직장"
        static let touchCompanyCardPreview = "C8 명함만들기_직장_미리보기"
        
        static let touchBackFromCompanyPreview = "C9 명함만들기_직장_미리보기_뒤로가기"
        static let touchPreviewCompanyComplete = "C9 명함만들기_직장_미리보기_완료"
        
        static let touchCardListPin = "C10 명함리스트_핀"
        
        static let touchEditGroup = "D1_명함모음_그룹편집"
        static let cardGroupList = "D1_명함모음"
        static let touchGroup2 = "D1_명함모음_그룹2"
        static let touchGroup3 = "D1_명함모음_그룹3"
        static let touchGroup4 = "D1_명함모음_그룹4"
        static let touchGroupCard = "D1_명함모음"
        
        static let touchEditGroupBack = "D2_그룹편집_뒤로가기"
        static let touchEditGroupAdd = "D2_그룹편집_그룹추가"
        static let touchEditGroup1 = "D2_그룹편집_그룹1"
        static let touchEditGroup2 = "D2_그룹편집_그룹2"
        static let touchEditGroup3 = "D2_그룹편집_그룹3"
        static let touchEditGroup4 = "D2_그룹편집_그룹4"
        
        static let touchCardDetailClose = "D3_명함상세_종료"
        static let touchCardDetailEdit = "D3_명함상세_수정"
        static let touchCardDetailEditGroup = "D3_명함상세_그룹변경"
        static let touchCardDetailDelete = "D3_명함상세_명함삭제"
        static let touchCardDetailCancel = "D3_명함상세_취소"
        static let touchCardDetailHarmony = "D3_명함상세_궁합"
        static let touchCardDetailBasicSNS = "D3_명함상세_SNS"
        static let touchCardDetailBasicUrl = "D3_명함상세_기본Url"
        static let touchCardDetailFanSNS = "D3_명함상세_덕질_SNS"
        static let touchCardDetailFanUrl1 = "D3_명함상세_덕질_Url1"
        static let touchCardDetailFanUrl2 = "D3_명함상세_덕질_Url2"
        static let touchCardDetailCompanyUrl = "D3_명함상세_직장_Url"
        
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
