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
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var linkURLLabel: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    
    @IBOutlet weak var instagramImageView: UIImageView!
    @IBOutlet weak var phoneNumberImageView: UIImageView!
    @IBOutlet weak var linkURLImageView: UIImageView!
    
    @IBOutlet weak var instagramStackView: UIStackView!
    @IBOutlet weak var phoneNumberStackView: UIStackView!
    @IBOutlet weak var linkURLStackView: UIStackView!
    @IBOutlet weak var totalStackView: UIStackView!
    
    @IBOutlet weak var titleLabelTop: NSLayoutConstraint!
    @IBOutlet weak var titleLabelLeading: NSLayoutConstraint!
    @IBOutlet weak var descLabelTop: NSLayoutConstraint!
    @IBOutlet weak var usernameLabelTop: NSLayoutConstraint!
    @IBOutlet weak var birthdayImageTop: NSLayoutConstraint!
    @IBOutlet weak var birthdayImageWidth: NSLayoutConstraint!
    @IBOutlet weak var mbtiImageLeading: NSLayoutConstraint!
    @IBOutlet weak var instagramImageWidth: NSLayoutConstraint!
    @IBOutlet weak var phoneImageWidth: NSLayoutConstraint!
    @IBOutlet weak var urlImageWidth: NSLayoutConstraint!
    @IBOutlet weak var totalStackViewBottom: NSLayoutConstraint!
    @IBOutlet weak var totalStackViewLeading: NSLayoutConstraint!
    @IBOutlet weak var totalStackViewTrailing: NSLayoutConstraint!
    
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
        birthLabel.font = .textRegular03
        birthLabel.textColor = .white
        mbtiLabel.font = .textRegular03
        mbtiLabel.textColor = .white
        instagramIDLabel.font = .textRegular03
        instagramIDLabel.textColor = .white
        instagramIDLabel.lineBreakMode = .byTruncatingTail
        phoneNumberLabel.font = .textRegular04
        phoneNumberLabel.textColor = .white
        phoneNumberLabel.lineBreakMode = .byTruncatingTail
        linkURLLabel.font = .textRegular04
        linkURLLabel.textColor = .white
        linkURLLabel.numberOfLines = 2
        linkURLLabel.lineBreakMode = .byTruncatingTail
        
        linkURLStackView.alignment = .center
    }
    func setConstraints() {
        let constraints = [titleLabelTop, titleLabelLeading, descLabelTop,
                           usernameLabelTop, birthdayImageTop, mbtiImageLeading, totalStackViewBottom, totalStackViewLeading, totalStackViewTrailing]
        let labels = [titleLabel, descriptionLabel, userNameLabel, birthLabel, mbtiLabel, instagramIDLabel, phoneNumberLabel, linkURLLabel]
        let widths = [birthdayImageWidth, phoneImageWidth, urlImageWidth]
        constraints.forEach {
            $0?.constant = ($0?.constant ?? 0) * (258/540)
        }
        labels.forEach {
            $0?.font = $0?.font.withSize(($0?.font.pointSize ?? 0) * 0.65)
        }
        widths.forEach {
            $0?.constant = 12
        }
        totalStackView.spacing = 5
        print("✅✅")
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
        instagramIDLabel.text = cardData.instagram
        phoneNumberLabel.text = cardData.phoneNumber
        
        if let urls = cardData.urls {
            if urls[0].isEmpty {
                linkURLStackView.isHidden = true
            } else {
                linkURLLabel.text = urls[0]
            }
        }
        if cardData.instagram?.isEmpty ?? false {
            instagramStackView.isHidden = true
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
        instagramIDLabel.text = frontCardDataModel.instagram
        phoneNumberLabel.text = frontCardDataModel.phoneNumber
        
        if let urls = frontCardDataModel.urls {
            if urls[0].isEmpty {
                linkURLStackView.isHidden = true
            } else {
                linkURLLabel.text = urls[0]
            }
        }
        
        if frontCardDataModel.instagram?.isEmpty ?? false {
            instagramStackView.isHidden = true
        }
        if frontCardDataModel.phoneNumber?.isEmpty ?? false {
            phoneNumberStackView.isHidden = true
        }
        
        shareButton.isHidden = true
    }
}
