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

// MARK: - Extensions

extension RequiredFlavorCollectionViewCell {
    private func setUI() {
        bgView.backgroundColor = .textBox
        bgView.cornerRadius = 10
        
        flavorLabel.font = .button02
        flavorLabel.textColor = .quaternary
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
                 flavorLabel.textColor = .background
            } else {
                 bgView.backgroundColor = .textBox
                 flavorLabel.textColor = .quaternary
            }
        }
    }
}
