//
//  GeneralAPI.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2021/11/01.
//

import Foundation

extension Const {
    struct URL {
        static let baseURL = "https://nada-api.n-e.kr/swagger-ui/"
        static let policyURL = "https://nadaitzme.notion.site/NADA-8385054bc2e44762a62f590534b2a24d"
        static let serviceURL =  "https://nadaitzme.notion.site/NADA-58544bc9f0a1493c94f223cab3a440d0"
        static let moyaURL = "https://github.com/Moya/Moya"
        static let skeletonURL = "https://github.com/Juanpe/SkeletonView"
        static let swiftLintURL = "https://github.com/realm/SwiftLint"
        static let cardSwiperURL = "https://github.com/JoniVR/VerticalCardSwiper"
        static let kakaoURL = "https://developers.kakao.com/sdk/reference/ios/release/KakaoSDKCommon/index.html"
        static let keyboardURL = "https://github.com/hackiftekhar/IQKeyboardManager"
        static let kingfisherURL = "https://github.com/onevcat/Kingfisher"
        static let indicatorURL = "https://github.com/ninjaprox/NVActivityIndicatorView"
        static let dynamicLinkURLPrefix = "https://itzmenada.page.link"
        
        // FIXME: - 동적링크를 웹에서 여는 경우 홍보 페이지로 이동할 수 있는 URL 로 릴리즈 전에 변경. 현재 과거 홍보 페이지 URL 로 설정해둠.
        static let opendDynamicLinkOnWebURL = "https://www.notion.so/nadaitzme/NADA-22c9c7fc3e00453fa12d885e6e58fe86"
    }
}
