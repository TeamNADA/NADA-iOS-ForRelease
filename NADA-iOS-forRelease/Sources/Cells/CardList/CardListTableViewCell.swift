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
    @IBOutlet weak var dateLabel: UILabel!
    
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
    
    // 핀 이미지 클릭 시
    @IBAction func pinButtonClicked(_ sender: Any) {
        let pinImage = UIImage(named: "pushPinBlackFilled")
        
        if pinButton.currentImage == pinImage {
            pinButton.setImage(UIImage(named: "pushPinBlack"), for: UIControl.State.normal)
        } else {
            pinButton.setImage(UIImage(named: "pushPinBlackFilled"), for: UIControl.State.normal)
        }
    }
    
    func initData(title: String,
                 date: String) {
        titleLabel.text = title
        dateLabel.text = date
    }
}
