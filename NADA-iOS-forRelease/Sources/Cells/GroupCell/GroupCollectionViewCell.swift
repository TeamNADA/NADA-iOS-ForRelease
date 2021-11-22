//
//  GroupCollectionViewCell.swift
//  NADA-iOS-forRelease
//
//  Created by Yi Joon Choi on 2021/11/21.
//

import UIKit

class GroupCollectionViewCell: UICollectionViewCell {

    // MARK: - @IBOutlet Properties
    @IBOutlet weak var groupBackground: UIView!
    @IBOutlet weak var groupName: UILabel!
    
    // MARK: - View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setUI()
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "GroupCollectionViewCell", bundle: nil)
    }
}

// MARK: - Extensions
extension GroupCollectionViewCell {
    private func setUI() {
        groupBackground.layer.cornerRadius = 15
        groupBackground.backgroundColor = .button
        groupName.textColor = .mainColorButtonText
    }
    
    override var isSelected: Bool {
        didSet {
            groupBackground.backgroundColor = isSelected ? .primary : .button
            groupName.textColor = isSelected ? .background : .mainColorButtonText
        }
    }
}
