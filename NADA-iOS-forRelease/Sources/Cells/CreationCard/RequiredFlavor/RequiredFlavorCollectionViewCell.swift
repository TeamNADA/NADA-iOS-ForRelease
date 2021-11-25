//
//  RequiredFlavorCell.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2021/09/27.
//

import UIKit

class RequiredFlavorCollectionViewCell: UICollectionViewCell {
    
    // MARK: - @IBOutlet Properties
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var flavorLabel: UILabel!
    
    // MARK: - Cell Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUI()
    }
}

extension RequiredFlavorCollectionViewCell {
    private func setUI() {
        bgView.backgroundColor = .textBox
        bgView.cornerRadius = 10
        
        flavorLabel.font = .button02
        flavorLabel.textColor = .tertiary
        flavorLabel.textAlignment = .center
    }
    func initCell(flavor: String) {
        flavorLabel.text = flavor
    }
    static func nib() -> UINib {
        return UINib(nibName: Const.Xib.requiredCollectionViewCell, bundle: nil)
    }
    override var isSelected: Bool {
        didSet {
            if isSelected {
                 bgView.backgroundColor = .secondary
                 flavorLabel.textColor = .primary
            } else {
                 bgView.backgroundColor = .textBox
                 flavorLabel.textColor = .tertiary
            }
        }
    }
}
