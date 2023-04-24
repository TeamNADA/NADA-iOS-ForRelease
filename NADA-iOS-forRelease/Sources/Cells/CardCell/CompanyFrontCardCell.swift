//
//  CompanyFrontCardCell.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2023/04/24.
//

import UIKit

import VerticalCardSwiper
import Kingfisher

class CompanyFrontCardCell: CardCell {
    
    // MARK: - Properties
    
    private var cardData: Card?
    
    // MARK: - @IBOutlet Properties
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var birthLabel: UILabel!
    @IBOutlet weak var mbtiLabel: UILabel!
    @IBOutlet weak var mailLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var linkURLLabel: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    
    @IBOutlet weak var mailImageView: UIImageView!
    @IBOutlet weak var phoneNumberImageView: UIImageView!
    @IBOutlet weak var linkURLImageView: UIImageView!
    
    @IBOutlet weak var mailStackView: UIStackView!
    @IBOutlet weak var phoneNumberStackView: UIStackView!
    @IBOutlet weak var linkURLStackView: UIStackView!
    @IBOutlet weak var totalStackView: UIStackView!
    
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
        return UINib(nibName: CompanyFrontCardCell.className, bundle: Bundle(for: CompanyFrontCardCell.self))
    }
}

// MARK: - Extensions

extension CompanyFrontCardCell {
    private func setUI() {
        titleLabel.font = .title02
        titleLabel.textColor = .white
        descriptionLabel.font = .textRegular03
        descriptionLabel.textColor = .white
        userNameLabel.font = .title01
        userNameLabel.textColor = .white
        birthLabel.font = .textRegular03
        birthLabel.textColor = .white
        mbtiLabel.font = .textRegular03
        mbtiLabel.textColor = .white
        mailLabel.font = .textRegular04
        mailLabel.textColor = .white
        mailLabel.lineBreakMode = .byTruncatingTail
        phoneNumberLabel.font = .textRegular04
        phoneNumberLabel.textColor = .white
        phoneNumberLabel.lineBreakMode = .byTruncatingTail
        linkURLLabel.font = .textRegular04
        linkURLLabel.textColor = .white
        linkURLLabel.numberOfLines = 2
        linkURLLabel.lineBreakMode = .byTruncatingTail
        
        linkURLStackView.alignment = .center
    }
    private func setTapGesture() {
        mailLabel.isUserInteractionEnabled = true
        let mailTapGesture = UITapGestureRecognizer(target: self, action: #selector(tapMailLabel))
        mailLabel.addGestureRecognizer(mailTapGesture)
        
        linkURLLabel.isUserInteractionEnabled = true
        let linkURLTapGesture = UITapGestureRecognizer(target: self, action: #selector(tapLinkURLLabel))
        linkURLLabel.addGestureRecognizer(linkURLTapGesture)
    }
    
    // MARK: - @objc Methods
    
    @objc
    private func tapMailLabel() {
        // TODO: - mail 앱 열기
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
    
    /// 명함 조회 시 사용.
    func initCellFromServer(cardData: Card, isShareable: Bool) {
        self.cardData = cardData
        
        if cardData.cardImage.hasPrefix("https://") {
            self.backgroundImageView.updateServerImage(cardData.cardImage)
        } else {
            if let bgImage = UIImage(named: cardData.cardImage) {
                self.backgroundImageView.image = bgImage
            }
        }
            
        titleLabel.text = cardData.cardName
        descriptionLabel.text = cardData.departmentName
        userNameLabel.text = cardData.userName
        birthLabel.text = cardData.birth
        mbtiLabel.text = cardData.mbti
        mailLabel.text = cardData.mailAddress
        phoneNumberLabel.text = cardData.phoneNumber
        
        if let urls = cardData.urls {
            if urls[0].isEmpty {
                linkURLStackView.isHidden = true
            } else {
                linkURLLabel.text = urls[0]
            }
        }
        if cardData.mailAddress?.isEmpty ?? false {
            mailStackView.isHidden = true
        }
        if cardData.phoneNumber?.isEmpty ?? false {
            phoneNumberStackView.isHidden = true
        }
        
        shareButton.isHidden = !isShareable
    }
    
    /// 명함 미리보기 시 사용.
    func initCell(_ backgroundImage: UIImage?,
                  _ frontCardDataModel: FrontCardDataModel) {
        backgroundImageView.image = backgroundImage ?? UIImage()
        titleLabel.text = frontCardDataModel.cardName
        descriptionLabel.text = frontCardDataModel.departmentName
        userNameLabel.text = frontCardDataModel.userName
        birthLabel.text = frontCardDataModel.birth
        mbtiLabel.text = frontCardDataModel.mbti
        mailLabel.text = frontCardDataModel.mailAddress
        phoneNumberLabel.text = frontCardDataModel.phoneNumber
        
        if let urls = frontCardDataModel.urls {
            if urls[0].isEmpty {
                linkURLStackView.isHidden = true
            } else {
                linkURLLabel.text = urls[0]
            }
        }
        
        if frontCardDataModel.mailAddress?.isEmpty ?? false {
            mailStackView.isHidden = true
        }
        if frontCardDataModel.phoneNumber?.isEmpty ?? false {
            phoneNumberStackView.isHidden = true
        }
        
        shareButton.isHidden = true
    }
}
