//
//  CardInGroupCollectionViewCell.swift
//  NADA-iOS-forRelease
//
//  Created by Yi Joon Choi on 2021/11/26.
//

import UIKit

class CardInGroupCollectionViewCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "CardInGroupCollectionViewCell", bundle: Bundle(for: CardInGroupCollectionViewCell.self))
    }

}
