//
//  EmptyCardListTableViewCell.swift
//  NADA-iOS-forRelease
//
//  Created by 민 on 2021/12/30.
//

import UIKit

class EmptyCardListTableViewCell: UITableViewCell {

    static func nib() -> UINib {
        return UINib(nibName: Const.Xib.EmptyCardListTableViewCell, bundle: Bundle(for: EmptyCardListTableViewCell.self))
    }
}
