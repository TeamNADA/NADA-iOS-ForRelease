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
    var groupID: Int?
    var cardUUID: String?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        backgroundImageView.image = UIImage()
        titleLabel.text = ""
        descriptionLabel.text = ""
        userNameLabel.text = ""
        birthLabel.text = ""
        mbtiLabel.text = ""
        instagramIDLabel.text = ""
        mbtiLabel.text = ""
        instagramIcon.isHidden = false
        urlIcon.isHidden = false
    }
    
    static func nib() -> UINib {
        return UINib(nibName: Const.Xib.cardInGroupCollectionViewCell, bundle: Bundle(for: CardInGroupCollectionViewCell.self))
    }

}
