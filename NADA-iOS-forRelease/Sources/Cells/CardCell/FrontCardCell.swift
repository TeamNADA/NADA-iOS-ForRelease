//
//  FrontCardCell.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2021/09/18.
//

import UIKit
import VerticalCardSwiper
import Kingfisher

class FrontCardCell: CardCell {
    
    // MARK: - Properties
    
    private var cardData: Card?
    
    // MARK: - @IBOutlet Properties
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var birthLabel: UILabel!
    @IBOutlet weak var mbtiLabel: UILabel!
    @IBOutlet weak var instagramIDLabel: UILabel!
    @IBOutlet weak var linkURLLabel: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    
    @IBOutlet weak var instagramImageView: UIImageView!
    @IBOutlet weak var linkURLImageView: UIImageView!
    
    // MARK: - Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
         
        setUI()
        setTapGesture()
    }
    @IBAction func touchShareButton(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name.presentCardShare, object: cardData, userInfo: nil)
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
        instagramIDLabel.lineBreakMode = .byTruncatingTail
        linkURLLabel.font = .textRegular04
        linkURLLabel.textColor = .white
        linkURLLabel.numberOfLines = 1
        linkURLLabel.lineBreakMode = .byTruncatingTail
    }
    private func setTapGesture() {
        instagramIDLabel.isUserInteractionEnabled = true
        let instagramTapGesture = UITapGestureRecognizer(target: self, action: #selector(tapInstagramLabel))
        instagramIDLabel.addGestureRecognizer(instagramTapGesture)
        
        linkURLLabel.isUserInteractionEnabled = true
        let linkURLTapGesture = UITapGestureRecognizer(target: self, action: #selector(tapLinkURLLabel))
        linkURLLabel.addGestureRecognizer(linkURLTapGesture)
    }
    
    // MARK: - @objc Methods
    
    @objc
    private func tapInstagramLabel() {
        let instagramID = instagramIDLabel.text ?? ""
        let appURL = URL(string: "instagram://user?username=\(instagramID)")!
        let webURL = URL(string: "https://instagram.com/\(instagramID)")!
        
        if UIApplication.shared.canOpenURL(appURL) {
            UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.open(webURL, options: [:], completionHandler: nil)
        }
    }
    @objc
    private func tapLinkURLLabel() {
        let linkURL = linkURLLabel.text ?? ""
        let webURL: URL
        
        if linkURL.hasPrefix("https://") {
            webURL = URL(string: linkURL)!
        } else {
            webURL = URL(string: "https://" + linkURL)!
        }
        
        if UIApplication.shared.canOpenURL(webURL) {
            UIApplication.shared.open(webURL, options: [:], completionHandler: nil)
        }
    }
    
    /// ???????????? image ??? URL ??? ????????? ?????? ??????.
    func initCellFromServer(cardData: Card, isShareable: Bool) {
        self.cardData = cardData
        
        if cardData.background.hasPrefix("https://") {
            self.backgroundImageView.updateServerImage(cardData.background)
        } else {
            if let bgImage = UIImage(named: cardData.background) {
                self.backgroundImageView.image = bgImage
            }
        }
            
        titleLabel.text = cardData.title
        descriptionLabel.text = cardData.cardDescription
        userNameLabel.text = cardData.name
        birthLabel.text = cardData.birthDate
        mbtiLabel.text = cardData.mbti
        instagramIDLabel.text = cardData.instagram
        linkURLLabel.text = cardData.link
        
        if let instagram = cardData.instagram, instagram.isEmpty {
            instagramImageView.isHidden = true
        }
        if let link = cardData.link, link.isEmpty {
            linkURLImageView.isHidden = true
        }
        
        shareButton.isHidden = !isShareable
    }
    
    /// ??????????????? ??? image ??? UIImage ??? ????????? ?????? ??????
    func initCell(_ backgroundImage: UIImage?,
                  _ cardTitle: String,
                  _ cardDescription: String,
                  _ userName: String,
                  _ birth: String,
                  _ mbti: String,
                  _ instagramID: String,
                  _ linkURL: String,
                  isShareable: Bool) {
        backgroundImageView.image = backgroundImage ?? UIImage()
        titleLabel.text = cardTitle
        descriptionLabel.text = cardDescription
        userNameLabel.text = userName
        birthLabel.text = birth
        mbtiLabel.text = mbti
        instagramIDLabel.text = instagramID
        linkURLLabel.text = linkURL
        
        if instagramID.isEmpty {
            instagramImageView.isHidden = true
        }
        if linkURL.isEmpty {
            linkURLImageView.isHidden = true
        }
        
        shareButton.isHidden = !isShareable
    }
}
