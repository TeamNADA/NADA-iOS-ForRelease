//
//  FrontCardCell.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2021/09/18.
//

import UIKit
import VerticalCardSwiper

class FrontCardCell: CardCell {
    
    // MARK: - @IBOutlet Properties
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var cardNameLabel: UILabel!
    @IBOutlet weak var detailCardNameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var birthLabel: UILabel!
    @IBOutlet weak var mbtiLabel: UILabel!
    @IBOutlet weak var instagramImageView: UIImageView!
    @IBOutlet weak var instagramTextLabel: UILabel!
    @IBOutlet weak var instagramIDLabel: UILabel!
    @IBOutlet weak var linkImageView: UIImageView!
    @IBOutlet weak var linkTextLabel: UILabel!
    @IBOutlet weak var linkIDLabel: UILabel!
    
    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
         setUI()
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "FrontCardCell", bundle: nil)
    }
}

// MARK: - Extensions

extension FrontCardCell {
    private func setUI() {
        // hidden 에 대한 속성도 여기 쓰자.
        
//        instagramImageView.image = UIImage(named: "instagramLogoImg")
        instagramTextLabel.text = "Instagram"
    }
    
    func initCell(_ backgroundImage: String,
                  _ cardName: String,
                  _ detailCardName: String,
                  _ userName: String,
                  _ birth: String,
                  _ mbti: String,
                  _ instagramID: String,
                  _ linkImage: String,
                  _ linkText: String,
                  _ linkID: String) {
        if let bgImage = UIImage(named: backgroundImage) {
            self.backgroundImageView.image = bgImage
        }
        self.cardNameLabel.text = cardName
        self.detailCardNameLabel.text = detailCardName
        self.userNameLabel.text = userName
        self.birthLabel.text = birth
        self.mbtiLabel.text = mbti
        self.instagramIDLabel.text = instagramID
        if let linkImage = UIImage(named: linkImage) {
            self.linkImageView.image = linkImage
        }
        self.linkTextLabel.text = linkText
        self.linkIDLabel.text = linkID
    }
}
