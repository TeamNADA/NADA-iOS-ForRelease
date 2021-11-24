//
//  CardListTableViewCell.swift
//  NADA-iOS-forRelease
//
//  Created by 민 on 2021/09/27.
//

import UIKit

class CardListTableViewCell: UITableViewCell {
    
    var delegate: CardListTableViewDelegate!
    
    @IBOutlet weak var pinButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var reorderButton: UIButton!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "CardListTableViewCell", bundle: nil)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func pinButtonConnected(_ sender: UIButton) {
        // delegate.pinChanged(self, pinButton)
    }
    
    func initData(title: String) {
        titleLabel.text = title
    }
}

protocol CardListTableViewDelegate {
    func pinChanged(_ cell: UITableViewCell, _ button: UIButton)
}
