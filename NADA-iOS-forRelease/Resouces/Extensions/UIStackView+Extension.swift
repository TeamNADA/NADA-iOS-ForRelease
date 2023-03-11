//
//  UIStackView+Extension.swift
//  NADA-iOS-forRelease
//
//  Created by Yi Joon Choi on 2023/03/11.
//

import UIKit

extension UIStackView {
    public func addArrangedSubviews(_ view: [UIView]) {
        view.forEach { self.addArrangedSubview($0) }
    }
}
