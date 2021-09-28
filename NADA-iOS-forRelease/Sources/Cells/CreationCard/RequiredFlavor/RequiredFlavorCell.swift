//
//  RequiredFlavorCell.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2021/09/27.
//

import UIKit

class RequiredFlavorCell: UICollectionViewCell {

    // MARK: - Properteis
    
    static let identifier = "RequiredFlavorCell"
    
    // MARK: - @IBOutlet Properties
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var flavorLabel: UILabel!
    
    // MARK: - Cell Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUI()
    }
}

extension RequiredFlavorCell {
    private func setUI() {
        bgView.backgroundColor = .systemGray2
        bgView.cornerRadius = 10
        
        flavorLabel.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 16)
        flavorLabel.textColor = .systemGray5
    }
    func initCell(flavor: String) {
        flavorLabel.text = flavor
    }
}
