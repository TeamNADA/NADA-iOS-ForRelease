//
//  UITextField+Extension.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2021/11/25.
//

import UIKit

extension UITextField {
    func addLeftPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
}
