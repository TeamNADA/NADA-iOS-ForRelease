//
//  OpenSourceTableViewCell.swift
//  NADA-iOS-forRelease
//
//  Created by 민 on 2021/12/11.
//

import UIKit

class OpenSourceTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    static func nib() -> UINib {
        return UINib(nibName: Const.Xib.openSourceTableViewCell, bundle: nil)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
