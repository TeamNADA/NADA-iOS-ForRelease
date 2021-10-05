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
        bgView.backgroundColor = Colors.inputBlack.color
        bgView.cornerRadius = 10
        
        flavorLabel.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 16)
        flavorLabel.textColor = Colors.hint.color
    }
    func initCell(flavor: String) {
        flavorLabel.text = flavor
    }
    static func nib() -> UINib {
        return UINib(nibName: "RequiredFlavorCollectionViewCell", bundle: nil)
    }
}
