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
        
        static let touchGiveCard = "B1_메인탭_명함주기"
        static let touchTakeCard = "B1_메인탭_명함받기"
        static let touchAroundMe = "B1_메인탭_내근처의명함"
        static let touchBanner = "B1_메인탭_상단배너_"
        static let touchMakeCard = "B1_메인탭_명함만들기"
        static let touchAd = "B1_메인탭_광고"
        
        static let touchAddByID = "B2 명함받기모달_ID로받기"
        static let touchAddByQR = "B2_명함받기모달_QR로받기"
        
        static let touchAddCard = "B5_명함받기모달_추가"
        
        static let touchSelectGroup = "B6_그룹선택모달_완료"
        
        static let touchAroundMeClose = "B7_내근처의명함_닫기"
        static let touchAroundMeRefresh = "B7_내근처의명함_새로고침"
        static let touchAroundMeAdd = "B7_내근처의명함_추가"
        
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
        static let touchReceivedTag = "C1_내명함_받은태그"
        static let touchTagEdit = "C1_내명함_태그_편집"
        static let touchTagCancel = "C1_내명함_태그_편집"
        static let touchTagDelete = "C1_내명함_태그_삭제"
        static let touchTag = "C1_내명함_태그_"
        
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
        static let touchCompanyTasteInfo = "C8_명함만들기_직장_"
        static let touchCompanyCardPreview = "C8_명함만들기_직장_미리보기"
        
        static let touchBackFromCompanyPreview = "C9_명함만들기_직장_미리보기_뒤로가기"
        static let touchPreviewCompanyComplete = "C9_명함만들기_직장_미리보기_완료"
        
        static let touchCardModify = "C10_명함리스트_수정"
        static let touchCardListPin = "C10_명함리스트_핀"
        
        static let touchEditGroup = "D1_명함모음_그룹편집"
        static let touchGroup = "D1_명함모음_그룹"
        static let touchGroupCard = "D1_명함모음_"
        
        static let touchEditGroupBack = "D2_그룹편집_뒤로가기"
        static let touchEditGroupAdd = "D2_그룹편집_그룹추가"
        static let touchEditGroupNumber = "D2_그룹편집_그룹"
        
        static let touchCardDetailClose = "D3_명함상세_종료"
        static let touchCardDetailEdit = "D3_명함상세_수정"
        static let touchCardDetailEditGroup = "D3_명함상세_그룹변경"
        static let touchCardDetailDelete = "D3_명함상세_명함삭제"
        static let touchCardDetailCancel = "D3_명함상세_취소"
        static let touchCardDetailHarmony = "D3_명함상세_궁합"
        static let touchCardDetailBasicSNS = "D3_명함상세_SNS"
        static let touchCardDetailBasicURL = "D3_명함상세_기본_url"
        static let touchCardDetailFanSNS = "D3_명함상세_덕질_SNS"
        static let touchCardDetailFanURL1 = "D3_명함상세_덕질_url1"
        static let touchCardDetailFanURL2 = "D3_명함상세_덕질_url2"
        static let touchCardDetailCompanyURL = "D3_명함상세_직장_url"
        static let touchCardDetailTagHelp = "D3_명함상세_태그도움말"
        static let touchCardDetailSendTag = "D3_명함상세_태그보내기"
        
        
        static let touchTagThema = "D4_태그_테마_"
        static let touchTagAdjective = "D4_태그_테마_형용사"
        static let touchTagNoun = "D4_태그_테마_명사"
        static let touchSendTagNextButton = "D4_태그_다음"
        static let touchSendTagBackButton = "D4_태그_뒤로가기"
        static let touchSendTagSendButton = "D4_태그_보내기"
        static let touchSendTagCompleteButton = "D4_태그_완료"
        
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
