//
//  EmptyGroupEditTableViewCell.swift
//  NADA-iOS-forRelease
//
//  Created by 민 on 2021/12/30.
//

import UIKit

class EmptyGroupEditTableViewCell: UITableViewCell {

    static func nib() -> UINib {
        return UINib(nibName: Const.Xib.EmptyGroupEditTableViewCell, bundle: Bundle(for: EmptyGroupEditTableViewCell.self))
    }
}
