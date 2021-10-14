//
//  CGPoint+Distance.swift
//  NADA-iOS-forRelease
//
//  Created by 민 on 2021/10/09.
//

import Foundation
import UIKit

extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        return hypot(self.x - point.x, self.y - point.y)
    }
}
