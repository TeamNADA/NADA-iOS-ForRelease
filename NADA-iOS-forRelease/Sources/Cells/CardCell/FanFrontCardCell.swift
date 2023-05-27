//
//  FrontCardCell.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2021/09/18.
//

import UIKit

import FirebaseAnalytics
import VerticalCardSwiper
import Kingfisher

class FanFrontCardCell: CardCell {
    
    // MARK: - Properties
    
    private var cardData: Card?
    private var setConstraintDone = false
    private var backgroundCornerRadius: CGFloat?
    
    public var cardContext: CardContext?
    
    // MARK: - @IBOutlet Properties
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var birthLabel: UILabel!
    @IBOutlet weak var snsLabel: UILabel!
    @IBOutlet weak var firstURLLabel: UILabel!
    @IBOutlet weak var secondURLLabel: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    
    @IBOutlet weak var snsImageView: UIImageView!
    @IBOutlet weak var firstURLImageView: UIImageView!
    @IBOutlet weak var secondURLImageView: UIImageView!
    
    @IBOutlet weak var snsStackView: UIStackView!
    @IBOutlet weak var firstURLStackView: UIStackView!
    @IBOutlet weak var secondURLStackView: UIStackView!
    @IBOutlet weak var totalStackView: UIStackView!
    
    @IBOutlet weak var titleLabelTop: NSLayoutConstraint!
    @IBOutlet weak var titleLabelBottom: NSLayoutConstraint!
    @IBOutlet weak var titleLabelLeading: NSLayoutConstraint!
    @IBOutlet weak var userNameBottom: NSLayoutConstraint!
    @IBOutlet weak var totalStackviewBottom: NSLayoutConstraint!
    @IBOutlet weak var totalStackviewLeading: NSLayoutConstraint!
    @IBOutlet weak var totalStackviewTrailing: NSLayoutConstraint!
    
    @IBOutlet weak var birthImageViewWidth: NSLayoutConstraint!
    @IBOutlet weak var snsImageViewWidth: NSLayoutConstraint!
    @IBOutlet weak var firstUrlWidth: NSLayoutConstraint!
    @IBOutlet weak var secondUrlWidth: NSLayoutConstraint!
    
    // MARK: - Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
         
        setUI()
        setTapGesture()
    }
    @IBAction func touchShareButton(_ sender: Any) {
        NotificationCenter.default.post(name: Notification.Name.presentCardShare, object: cardData, userInfo: nil)
        
        guard let cardContext else { return }
        
        // TODO: - CardContext
        switch cardContext {
        case .myCard:
            Analytics.logEvent(Tracking.Event.touchFanCardShare, parameters: nil)
        }
    }
    
    static func nib() -> UINib {
        return UINib(nibName: FanFrontCardCell.className, bundle: Bundle(for: FanFrontCardCell.self))
    }
}

// MARK: - Extensions

extension FanFrontCardCell {
    private func setUI() {
        titleLabel.font = .title02
        titleLabel.textColor = .white
        
        userNameLabel.font = .title01
        userNameLabel.textColor = .white
        
        birthLabel.font = .textRegular03
        birthLabel.textColor = .white
        
        snsLabel.font = .textRegular03
        snsLabel.textColor = .white
        snsLabel.lineBreakMode = .byTruncatingTail
        
        firstURLLabel.font = .textRegular04
        firstURLLabel.textColor = .white
        firstURLLabel.numberOfLines = 1
        firstURLLabel.lineBreakMode = .byTruncatingTail
        
        secondURLLabel.font = .textRegular04
        secondURLLabel.textColor = .white
        secondURLLabel.numberOfLines = 1
        secondURLLabel.lineBreakMode = .byTruncatingTail
        
        firstURLStackView.alignment = .center
        
        secondURLStackView.alignment = .center
        
        backgroundImageView.cornerRadius = backgroundCornerRadius ?? 20
    }
    func setConstraints() {
        if setConstraintDone { return }
        setConstraintDone = true
        
        let constraints = [titleLabelTop, titleLabelBottom, titleLabelLeading,
                           userNameBottom, totalStackviewBottom, totalStackviewLeading, totalStackviewTrailing]
        let labels = [titleLabel, userNameLabel, birthLabel, snsLabel, firstURLLabel, secondURLLabel]
        let widths = [birthImageViewWidth, snsImageViewWidth, firstUrlWidth, secondUrlWidth]
        
        constraints.forEach {
            $0?.constant = ($0?.constant ?? 0) * 0.6
        }
        labels.forEach {
            $0?.font = $0?.font.withSize(($0?.font.pointSize ?? 0) * 0.6)
        }
        widths.forEach {
            $0?.constant = 12
        }
        totalStackView.spacing = 5
    }
    private func setTapGesture() {
        snsLabel.isUserInteractionEnabled = true
        let instagramTapGesture = UITapGestureRecognizer(target: self, action: #selector(tapSNSLabel))
        snsLabel.addGestureRecognizer(instagramTapGesture)
        
        firstURLLabel.isUserInteractionEnabled = true
        let firstURLTapGesture = UITapGestureRecognizer(target: self, action: #selector(touchFirstURLLabel))
        firstURLLabel.addGestureRecognizer(firstURLTapGesture)
        
        secondURLLabel.isUserInteractionEnabled = true
        let secondURLTapGesture = UITapGestureRecognizer(target: self, action: #selector(touchSecondURLLabel))
        secondURLLabel.addGestureRecognizer(secondURLTapGesture)
    }
    public func setCornerRadius(_ cornerRadius: CGFloat) {
        backgroundCornerRadius = cornerRadius
    }
    
    // MARK: - @objc Methods
    
    @objc
    private func tapSNSLabel() {
        let appURL: URL?
        let webURL: URL?
        
        if cardData?.instagram != nil {
            let instagramID = snsLabel.text ?? ""
            appURL = URL(string: "instagram://user?username=\(instagramID)")
            webURL = URL(string: "https://instagram.com/\(instagramID)")
        } else {
            let twitterID = snsLabel.text ?? ""
            appURL = URL(string: "twitter://user?id=\(twitterID)")
            webURL = URL(string: "https://twitter.com/\(twitterID)")
        }
        guard let appURL, let webURL else { return }
        
        if UIApplication.shared.canOpenURL(appURL) {
            UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.open(webURL, options: [:], completionHandler: nil)
        }
        
        guard let cardContext else { return }
        
        // TODO: - CardContext
        switch cardContext {
        case .myCard:
            Analytics.logEvent(Tracking.Event.touchFanCardSNS, parameters: nil)
        }
    }
    @objc
    private func touchFirstURLLabel() {
        tapLinkURLLabel(with: firstURLLabel.text ?? "")
        
        guard let cardContext else { return }
        
        // TODO: - CardContext
        switch cardContext {
        case .myCard:
            Analytics.logEvent(Tracking.Event.touchFanCardURL1, parameters: nil)
        }
    }
    @objc
    private func touchSecondURLLabel() {
        tapLinkURLLabel(with: secondURLLabel.text ?? "")
        
        guard let cardContext else { return }
        
        // TODO: - CardContext
        switch cardContext {
        case .myCard:
            Analytics.logEvent(Tracking.Event.touchFanCardURL2, parameters: nil)
        }
    }
    @objc
    private func tapLinkURLLabel(with text: String) {
        let linkURL = text
        let webURL: URL?
        
        if linkURL.hasPrefix("https://") {
            webURL = URL(string: linkURL)
        } else {
            webURL = URL(string: "https://" + linkURL)
        }
        
        guard let webURL else { return }
        
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
        userNameLabel.text = cardData.userName
        birthLabel.text = cardData.birth
        
        if cardData.instagram == nil {
            snsLabel.text = cardData.twitter
            snsImageView.image = UIImage(named: "iconTwitter")
        } else {
            snsLabel.text = cardData.instagram
            snsImageView.image = UIImage(named: "iconInstagram")
        }

        if cardData.instagram == nil &&
            cardData.twitter == nil {
            snsStackView.isHidden = true
        }

        if let urls = cardData.urls {
            if urls != [""] {
                if urls.count == 1 {
                    firstURLLabel.text = urls[0]
                    
                    secondURLStackView.isHidden = true
                } else {
                    firstURLLabel.text = urls[0]
                    secondURLLabel.text = urls[1]
                }
            } else {
                firstURLStackView.isHidden = true
                secondURLStackView.isHidden = true
            }
        }
        
        shareButton.isHidden = !isShareable
    }
    
    /// 명함 미리보기 시 사용.
    func initCell(_ backgroundImage: UIImage?,
                  _ frontCardDataModel: FrontCardDataModel) {
        backgroundImageView.image = backgroundImage ?? UIImage()
        titleLabel.text = frontCardDataModel.cardName
        userNameLabel.text = frontCardDataModel.userName
        birthLabel.text = frontCardDataModel.birth
        
        if frontCardDataModel.instagram == nil {
            snsLabel.text = frontCardDataModel.twitter
            snsImageView.image = UIImage(named: "iconTwitter")
        } else {
            snsLabel.text = frontCardDataModel.instagram
            snsImageView.image = UIImage(named: "iconInstagram")
        }

        if frontCardDataModel.instagram == nil &&
            frontCardDataModel.twitter == nil {
            snsStackView.isHidden = true
        }
        
        if let urls = frontCardDataModel.urls {
            if urls != [""] {
                if urls.count == 1 {
                    firstURLLabel.text = urls[0]
                    
                    secondURLStackView.isHidden = true
                } else {
                    firstURLLabel.text = urls[0]
                    secondURLLabel.text = urls[1]
                }
            } else {
                firstURLStackView.isHidden = true
                secondURLStackView.isHidden = true
            }
        }
        
        shareButton.isHidden = true
    }
}
