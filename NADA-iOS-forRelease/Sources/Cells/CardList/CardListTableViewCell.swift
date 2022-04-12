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
        
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    static func nib() -> UINib {
        return UINib(nibName: Const.Xib.cardListTableViewCell, bundle: nil)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func initData(title: String) {
        titleLabel.text = title
    }
}
