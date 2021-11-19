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
        // bgView.backgroundColor = .inputBlack2
        bgView.cornerRadius = 10
        
        // flavorLabel.font = .hint
        // flavorLabel.textColor = .hintGray1
        flavorLabel.lineBreakMode = .byTruncatingTail
        flavorLabel.textAlignment = .center
    }
    func initCell(flavor: String) {
        flavorLabel.text = flavor
    }
    static func nib() -> UINib {
        return UINib(nibName: "RequiredFlavorCollectionViewCell", bundle: nil)
    }
    override var isSelected: Bool {
        didSet {
            if isSelected {
                // bgView.backgroundColor = .white1
                // flavorLabel.textColor = .black1
            } else {
                // bgView.backgroundColor = .inputBlack2
                // flavorLabel.textColor = .hintGray1
            }
        }
    }
}
