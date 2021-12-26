//
//  UIString+Extension.swift
//  NADA-iOS-forRelease
//
//  Created by Yi Joon Choi on 2021/12/26.
//

import Foundation
extension String {
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
}
