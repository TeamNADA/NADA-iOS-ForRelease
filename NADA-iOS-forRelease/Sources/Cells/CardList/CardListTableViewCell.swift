//
//  CardListTableViewCell.swift
//  NADA-iOS-forRelease
//
//  Created by 민 on 2021/09/27.
//

import UIKit

class CardListTableViewCell: UITableViewCell {
        
    @IBOutlet weak var pinButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var reorderButton: UIButton!
    
    static func nib() -> UINib {
        return UINib(nibName: Const.Xib.cardListTableViewCell, bundle: nil)
    }
    
    func initData(title: String) {
        titleLabel.text = title
    }
}
