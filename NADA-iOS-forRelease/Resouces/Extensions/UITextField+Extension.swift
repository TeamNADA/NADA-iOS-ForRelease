//
//  UITextField+Extension.swift
//  NADA-iOS-forRelease
//
//  Created by 민 on 2021/11/24.
//

import Foundation
import UIKit

extension UITextField {
    // 왼쪽에 여백 주기
    func setLeftPaddingPoints(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    // 오른쪽에 여백 주기
    func setRightPaddingPoints(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}
