//
//  CardInGroupCollectionViewCell.swift
//  NADA-iOS-forRelease
//
//  Created by Yi Joon Choi on 2021/11/26.
//

import UIKit

class CardInGroupCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var birthLabel: UILabel!
    @IBOutlet weak var mbtiLabel: UILabel!
    
    @IBOutlet weak var instagramIDLabel: UILabel!
    @IBOutlet weak var lineURLLabel: UILabel!
    
    @IBOutlet weak var instagramIcon: UIImageView!
    @IBOutlet weak var urlIcon: UIImageView!
    var groupId: Int?
    var cardId: String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUI()
    }
    
    static func nib() -> UINib {
        return UINib(nibName: Const.Xib.cardInGroupCollectionViewCell, bundle: Bundle(for: CardInGroupCollectionViewCell.self))
    }

}

extension CardInGroupCollectionViewCell {
    private func setUI() {
        
//        backgroundImageView.alpha = 0.4
    }
}
