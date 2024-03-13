//
//  EmptyCardCell.swift
//  NADA-iOS-forRelease
//
//  Created by 민 on 2021/12/15.
//

import UIKit
import VerticalCardSwiper

class EmptyCardCell: CardCell {

    // MARK: - Methods
    
    static func nib() -> UINib {
        return UINib(nibName: Const.Xib.emptyCardCell, bundle: Bundle(for: EmptyCardCell.self))
    }

}
