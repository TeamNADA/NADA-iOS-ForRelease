//
//  EmptyCardListTableViewCell.swift
//  NADA-iOS-forRelease
//
//  Created by 민 on 2021/12/30.
//

import UIKit

class EmptyCardListTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static func nib() -> UINib {
        return UINib(nibName: Const.Xib.EmptyCardListTableViewCell, bundle: Bundle(for: EmptyCardListTableViewCell.self))
    }
}
