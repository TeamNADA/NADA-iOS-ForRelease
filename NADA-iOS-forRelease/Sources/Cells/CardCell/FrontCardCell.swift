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
    @IBOutlet weak var instagramIDLabel: UILabel!
    @IBOutlet weak var linkURLLabel: UILabel!
    
    // MARK: - Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
         setUI()
    }
    
    static func nib() -> UINib {
        return UINib(nibName: Const.Xib.frontCardCell, bundle: Bundle(for: FrontCardCell.self))
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
        instagramIDLabel.font = .textRegular03
        instagramIDLabel.textColor = .white
        linkURLLabel.font = .textRegular04
        linkURLLabel.textColor = .white
        linkURLLabel.numberOfLines = 2
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
        titleLabel.text = cardTitle
        descriptionLabel.text = cardDescription
        userNameLabel.text = userName
        birthLabel.text = birth
        mbtiLabel.text = mbti
        instagramIDLabel.text = instagramID
        linkURLLabel.text = linkURL
    }
    
    // FIXME: - UIImage 로 넘어올때. 나중에 어떻게 사용할지 정해야함.
    func initCell(_ backgroundImage: UIImage?,
                  _ cardTitle: String,
                  _ cardDescription: String,
                  _ userName: String,
                  _ birth: String,
                  _ mbti: String,
                  _ instagramID: String,
                  _ linkURL: String) {
        backgroundImageView.image = backgroundImage ?? UIImage()
        titleLabel.text = cardTitle
        descriptionLabel.text = cardDescription
        userNameLabel.text = userName
        birthLabel.text = birth
        mbtiLabel.text = mbti
        instagramIDLabel.text = instagramID
        linkURLLabel.text = linkURL
    }
}
