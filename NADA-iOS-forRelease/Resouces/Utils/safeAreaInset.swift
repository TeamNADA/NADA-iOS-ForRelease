//
//  safeAreaInset.swift
//  NADA-iOS-forRelease
//
//  Created by Yi Joon Choi on 11/16/23.
//

import Foundation
import UIKit

public let STATUS_HEIGHT = UIApplication.shared.statusBarFrame.size.height   // 상태바 높이

/**
 # safeAreaTopInset
 - Note: 현재 디바이스의 safeAreaTopInset값 반환
 */
func safeAreaTopInset() -> CGFloat {
    if #available(iOS 11.0, *) {
        let window = UIApplication.shared.keyWindow
        let topPadding = window?.safeAreaInsets.top
        return topPadding ?? STATUS_HEIGHT
    } else {
        return STATUS_HEIGHT
    }
}

/**
 # safeAreaBottomInset
 - Note: 현재 디바이스의 safeAreaBottomInset값 반환
 */
func safeAreaBottomInset() -> CGFloat {
    if #available(iOS 11.0, *) {
        let window = UIApplication.shared.keyWindow
        let bottomPadding = window?.safeAreaInsets.bottom
        return bottomPadding ??  0.0
    } else {
        return 0.0
    }
}

