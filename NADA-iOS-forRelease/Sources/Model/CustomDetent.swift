//
//  CustomDetent.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 10/13/23.
//

import UIKit

private let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
private let safeAreaBottom = windowScene?.windows.first?.safeAreaInsets.bottom ?? 0

@available(iOS 16.0, *)
struct CustomDetent {
    static let receivedTagDetent = UISheetPresentationController.Detent.custom(identifier: .init("receivedTagDetent")) { _ in
        return 572 - safeAreaBottom
    }
    
//    static let editTagDetent = UISheetPresentationController.Detent.custom(identifier: .init("editTagDetent")) { _ in
//        return 304 - safeAreaBottom
//    }
    
    static let sendTagDetent = UISheetPresentationController.Detent.custom(identifier: .init("sendTagDetent")) { _ in
        return 388 - safeAreaBottom
    }
}
