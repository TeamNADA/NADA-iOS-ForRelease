//
//  Storyboard.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2021/08/08.
//

import Foundation
import UIKit

/*
 
 - Description:
 enum형태로 Storybaords 값을 안전하게 가져오기 위해 사용합니다.
 스토리보드를 추가할때마다 case 과 값을 추가하면 됩니다!
 - UIStoryboard.list(.base)와 같이 사용
 
 @creds to Song jihun (github: https://github.com/i-colours-u)
 */

enum Storyboards: String {
    case cardCreation = "CardCreation"
    case fanCardCreation = "FanCardCreation"
    case companyCardCreation = "CompanyCardCreation"
    case login = "Login"
    case cardList = "CardList"
    case front = "Front"
    case group = "Group"
    case groupEdit = "GroupEdit"
    case qrScan = "QRScan"
    case cardDetail = "CardDetail"
    case cardHarmony = "CardHarmony"
    case tabBar = "TabBar"
    case cardCreationPreview = "CardCreationPreview"
    case more = "More"
    case splash = "Splash"
    case onboarding = "Onboarding"
    case openSource = "OpenSource"
    case teamNADA = "TeamNADA"
}

extension UIStoryboard {
    static func list(_ name: Storyboards) -> UIStoryboard {
        return UIStoryboard(name: name.rawValue, bundle: nil)
    }
}

extension Const {
    struct Storyboard {
        
        struct Name {
            static let cardCreation = "CardCreation"
            static let login = "Login"
            static let cardList = "CardList"
            static let front = "Front"
            static let group = "Group"
            static let groupEdit = "GroupEdit"
            static let qrScan = "QRScan"
            static let cardDetail = "CardDetail"
            static let cardHarmony = "CardHarmony"
            static let tabBar = "TabBar"
            static let cardCreationPreview = "CardCreationPreview"
            static let more = "More"
            static let splash = "Splash"
            static let onboarding = "Onboarding"
            static let openSource = "OpenSource"
            static let teamNADA = "TeamNADA"
        }
        
    }
}
