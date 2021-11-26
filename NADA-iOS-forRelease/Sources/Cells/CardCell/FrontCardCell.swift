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
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var birthLabel: UILabel!
    @IBOutlet weak var mbtiLabel: UILabel!
    @IBOutlet weak var instagramImageView: UIImageView!
    @IBOutlet weak var instagramIDLabel: UILabel!
    @IBOutlet weak var linkURLImageView: UIImageView!
    @IBOutlet weak var linkURLLabel: UILabel!
    
    // MARK: - Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
         setUI()
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "FrontCardCell", bundle: Bundle(for: FrontCardCell.self))
    }
}

// MARK: - Extensions

extension FrontCardCell {
    private func setUI() {
        titleLabel.font = .title02
        titleLabel.textColor = .white
        descriptionLabel.font = .textRegular03
        descriptionLabel.textColor = .white
        userNameLabel.font = .title01
        userNameLabel.textColor = .white
        birthLabel.font = .textRegular02
        birthLabel.textColor = .white
        mbtiLabel.font = .textRegular02
        mbtiLabel.textColor = .white
        instagramIDLabel.font = .textRegular02
        instagramIDLabel.textColor = .white
        linkURLLabel.font = .textRegular02
        linkURLLabel.textColor = .white
    }
    
    func initCell(_ backgroundImage: String,
                  _ cardTitle: String,
                  _ cardDescription: String,
                  _ userName: String,
                  _ birth: String,
                  _ mbti: String,
                  _ instagramID: String,
                  _ linkURL: String) {
        if let bgImage = UIImage(named: backgroundImage) {
            self.backgroundImageView.image = bgImage
        }
        self.titleLabel.text = cardTitle
        self.descriptionLabel.text = cardDescription
        self.userNameLabel.text = userName
        self.birthLabel.text = birth
        self.mbtiLabel.text = mbti
        self.instagramIDLabel.text = instagramID
        self.linkURLLabel.text = linkURL
    }
}
