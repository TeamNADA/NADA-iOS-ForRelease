//
//  CustomTabIndicatorView.swift
//  NADA-iOS-forRelease
//
//  Created by 민 on 2021/10/09.
//

import Foundation
import UIKit

open class CustomTabIndicatorView: UIView {
    override open func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.bounds.height / 2
    }
    
    override open func tintColorDidChange() {
        super.tintColorDidChange()
        self.backgroundColor = tintColor
    }
}
