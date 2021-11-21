//
//  GroupCollectionViewCell.swift
//  NADA-iOS-forRelease
//
//  Created by Yi Joon Choi on 2021/11/21.
//

import UIKit

class GroupCollectionViewCell: UICollectionViewCell {

    // MARK: - @IBOutlet Properties
    @IBOutlet weak var groupButton: UIButton!
    
    // MARK: - View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setUI()
    }
}

// MARK: - Extensions
extension GroupCollectionViewCell {
    private func setUI(){
        groupButton.layer.cornerRadius = 15
        groupButton.setTitleColor(.mainColorButtonText, for: .normal)
        groupButton.setTitleColor(.background, for: .selected)
    }
    
    override var isSelected: Bool{
        didSet{
            groupButton.backgroundColor = isSelected ? .primary : .button
        }
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "GroupCollectionViewCell", bundle: nil)
    }
}
