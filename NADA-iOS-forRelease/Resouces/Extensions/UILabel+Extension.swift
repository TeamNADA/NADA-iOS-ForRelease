//
//  UILabel+Extension.swift
//  NADA-iOS-forRelease
//
//  Created by Yi Joon Choi on 2023/05/08.
//

import Foundation
import UIKit

extension UILabel {
    func addCharacterColor(color: UIColor, range: String) {
        if let labelText = text, labelText.count > 0 {
            let attributedStr = NSMutableAttributedString(string: labelText)
            attributedStr.addAttribute(.foregroundColor, value: color, range: (labelText as NSString).range(of: range))
            attributedText = attributedStr
        }
    }
}
