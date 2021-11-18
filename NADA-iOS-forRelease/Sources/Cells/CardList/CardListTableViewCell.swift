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
        return UINib(nibName: "CardListTableViewCell", bundle: nil)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // 핀 이미지 클릭 시
    @IBAction func pinButtonClicked(_ sender: Any) {
        let pinImage = UIImage(named: "iconPin")
        let reorderImage = UIImage(named: "iconReorder")
        
        if pinButton.currentImage == pinImage {
            pinButton.setImage(UIImage(named: "iconPinInactive"), for: UIControl.State.normal)
            reorderButton.isHidden = false
        } else {
            pinButton.setImage(UIImage(named: "iconPin"), for: UIControl.State.normal)
            reorderButton.isHidden = true
        }
    }
    
    @IBAction func reorderButtonClicked(_ sender: Any) {
        
    }
    
    func initData(title: String) {
        titleLabel.text = title
    }
}
