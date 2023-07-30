//
//  FanFrontCardCreationCollectionViewCell.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2023/04/23.
//

import UIKit

import FirebaseAnalytics
import IQKeyboardManagerSwift

class FanFrontCardCreationCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Protocols
    
    public weak var frontCardCreationDelegate: FrontCardCreationDelegate?
    
    // MARK: - Properties
    
    private let backgroundList = ["", "imageDefaultBg01", "imageDefaultBg02", "imageDefaultBg03", "imageDefaultBg04", "imageDefaultBg05", "imageDefaultBg06", "imageDefaultBg07"]
    private var requiredTextFieldList = [UITextField]()
    private var optionalTextFieldList = [UITextField]()
    private var cardBackgroundImage: UIImage?
    private var defaultImageIndex: Int?
    private var isInstagram: Bool?
    
    private let maxLength: Int = 15
  
    public var presentingBirthBottomVCClosure: (() -> Void)?
    
    // MARK: - @IBOutlet Properties
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var setBackgroundTextLabel: UILabel!
    @IBOutlet weak var cardTitleInfoTextLabel: UILabel!
    @IBOutlet weak var requiredInfoTextLabel: UILabel!
    @IBOutlet weak var optionalInfoTextLabel: UILabel!
    
    @IBOutlet weak var backgroundSettingCollectionView: UICollectionView!
    @IBOutlet weak var cardTitleTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!

    @IBOutlet weak var birthLabel: UILabel!
    @IBOutlet weak var birthView: UIView!

    @IBOutlet weak var instagramButton: UIButton!
    @IBOutlet weak var twitterButton: UIButton!
    
    @IBOutlet weak var snsTextField: UITextField!
    @IBOutlet weak var firstURLTextField: UITextField!
    @IBOutlet weak var secondURLTextField: UITextField!
    
    @IBOutlet weak var bgView: UIView!
    
    // MARK: - Cell Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUI()
        setTapAction()
        registerCell()
        textFieldDelegate()
        setNotification()
    }
    
    // MARK: - IBAction Methods
    
    @IBAction func touchInstagramButton(_ sender: Any) {
        isInstagram = true
        
        if twitterButton.isSelected == true {
            twitterButton.isSelected.toggle()
        }
        instagramButton.isSelected.toggle()
        
    }
    @IBAction func touchTwitterButton(_ sender: Any) {
        isInstagram = false
        
        if instagramButton.isSelected == true {
            instagramButton.isSelected.toggle()
        }
        twitterButton.isSelected.toggle()
    }
}

// MARK: - Extensions

extension FanFrontCardCreationCollectionViewCell {
    private func setUI() {
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        initUITextFieldList()
        backgroundSettingCollectionView.showsHorizontalScrollIndicator = false
        scrollView.indicatorStyle = .default
        scrollView.backgroundColor = .background
        bgView.backgroundColor = .background
        backgroundSettingCollectionView.backgroundColor = .background
        
        let collectionViewLayout = backgroundSettingCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
        collectionViewLayout?.estimatedItemSize = .zero
        collectionViewLayout?.scrollDirection = .horizontal
        
        let backgroundAttributeString = NSMutableAttributedString(string: "*명함의 배경을 선택해 주세요.")
        backgroundAttributeString.addAttribute(.foregroundColor, value: UIColor.mainColorNadaMain, range: NSRange(location: 0, length: 1))
        backgroundAttributeString.addAttribute(.foregroundColor, value: UIColor.secondary, range: NSRange(location: 1, length: backgroundAttributeString.length - 1))
        setBackgroundTextLabel.attributedText = backgroundAttributeString
        setBackgroundTextLabel.font = .textBold01
        
        let cardTitleAttributeString = NSMutableAttributedString(string: "*명함에 이름을 붙여 주세요.")
        cardTitleAttributeString.addAttribute(.foregroundColor, value: UIColor.mainColorNadaMain, range: NSRange(location: 0, length: 1))
        cardTitleAttributeString.addAttribute(.foregroundColor, value: UIColor.secondary, range: NSRange(location: 1, length: cardTitleAttributeString.length - 1))
        cardTitleInfoTextLabel.attributedText = cardTitleAttributeString
        cardTitleInfoTextLabel.font = .textBold01
        
        let requiredAttributeString = NSMutableAttributedString(string: "*명함에 대한 기본정보를 입력해 주세요.")
        requiredAttributeString.addAttribute(.foregroundColor, value: UIColor.mainColorNadaMain, range: NSRange(location: 0, length: 1))
        requiredAttributeString.addAttribute(.foregroundColor, value: UIColor.secondary, range: NSRange(location: 1, length: requiredAttributeString.length - 1))
        requiredInfoTextLabel.attributedText = requiredAttributeString
        requiredInfoTextLabel.font = .textBold01
        
        optionalInfoTextLabel.text = "내 명함을 더 표현할 수 있는 정보가 있나요?"
        optionalInfoTextLabel.font = .textBold01
        optionalInfoTextLabel.textColor = .secondary
        
        cardTitleTextField.attributedPlaceholder = NSAttributedString(string: "명함 이름 (15자)", attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.quaternary
        ])
        userNameTextField.attributedPlaceholder = NSAttributedString(string: "닉네임 (15자)", attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.quaternary
        ])

        birthView.layer.cornerRadius = 10
        birthView.backgroundColor = .textBox
        birthLabel.font = .textRegular04
        birthLabel.textColor = .quaternary
        birthLabel.text = "기념일 (최애 생일, 입덕일, 내 생일, 데뷔일 등)"
        
        instagramButton.setImage(UIImage(named: "iconDisabledInstagram"), for: .normal)
        instagramButton.setImage(UIImage(named: "iconInstagramSelected"), for: .selected)
        instagramButton.setTitle("", for: .normal)
        instagramButton.tintColor = .white
        
        twitterButton.setImage(UIImage(named: "iconDisabledTwitter"), for: .normal)
        twitterButton.setImage(UIImage(named: "iconTwitterSelected"), for: .selected)
        twitterButton.setTitle("", for: .normal)
        twitterButton.tintColor = .white
        
        snsTextField.attributedPlaceholder = NSAttributedString(string: "SNS (instagram / twitter)",
                                                                        attributes: [
                                                                            NSAttributedString.Key.foregroundColor: UIColor.quaternary
                                                                        ])
        firstURLTextField.attributedPlaceholder = NSAttributedString(string: "URL 1 (fancafe, youtube)",
                                                                    attributes: [
                                                                        NSAttributedString.Key.foregroundColor: UIColor.quaternary
                                                                    ])
        secondURLTextField.attributedPlaceholder = NSAttributedString(string: "URL 2 (fancafe, youtube)",
                                                                        attributes: [
                                                                            NSAttributedString.Key.foregroundColor: UIColor.quaternary
                                                                        ])
        
        _ = requiredTextFieldList.map {
            $0.font = .textRegular04
            $0.backgroundColor = .textBox
            $0.textColor = .primary
            $0.layer.cornerRadius = 10
            $0.borderStyle = .none
            $0.setLeftPaddingPoints(12)
        }
        _ = optionalTextFieldList.map {
            $0.font = .textRegular04
            $0.backgroundColor = .textBox
            $0.textColor = .primary
            $0.layer.cornerRadius = 10
            $0.borderStyle = .none
            $0.setLeftPaddingPoints(12)
        }
    }
    private func setTapAction() {
        let birthViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(touchBirthView))
        birthView.addGestureRecognizer(birthViewTapGesture)
    }
    private func initUITextFieldList() {
        requiredTextFieldList.append(contentsOf: [
            cardTitleTextField,
            userNameTextField
        ])
        optionalTextFieldList.append(contentsOf: [
            snsTextField,
            firstURLTextField,
            secondURLTextField
        ])
    }
    private func registerCell() {
        backgroundSettingCollectionView.delegate = self
        backgroundSettingCollectionView.dataSource = self
        
        backgroundSettingCollectionView.register(BackgroundCollectionViewCell.nib(), forCellWithReuseIdentifier: Const.Xib.backgroundCollectionViewCell)
    }
    private func textFieldDelegate() {
        _ = requiredTextFieldList.map { $0.delegate = self }
        _ = optionalTextFieldList.map { $0.delegate = self }
    }
    private func setNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(setBirthText(notification:)), name: .completeFrontCardBirth, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setCardBackgroundImage(notifiation:)), name: .sendNewImage, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChange(_:)), name: UITextField.textDidChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(dismissBorderLine), name: .dismissRequiredBottomSheet, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(cancelImagePicker), name: .cancelImagePicker, object: nil)
    }
    
    /// front card 가 편집되었는지. 필수 항목이 다 입력되었는지 체크.
    private func checkFrontCradStatus() {
        frontCardCreationDelegate?.frontCardCreation(endEditing: true)
        if cardTitleTextField.hasText &&
            userNameTextField.hasText &&
            birthLabel.text != "생년월일" &&
            defaultImageIndex != nil {
            frontCardCreationDelegate?.frontCardCreation(requiredInfo: true)
        } else {
            frontCardCreationDelegate?.frontCardCreation(requiredInfo: false)
        }
        if let defaultImageIndex {
            var instagramID: String?
            var twitterID: String?
            
            if let isInstagram {
                if isInstagram {
                    instagramID = snsTextField.text
                } else {
                    twitterID = snsTextField.text
                }
            }
            
            if let text = snsTextField.text,
               text.isEmpty {
                instagramID = nil
                twitterID = nil
            }
            
            var urls: [String] = []
            
            [firstURLTextField.text ?? "", secondURLTextField.text ?? ""].forEach { url in
                if url != "" {
                    urls.append(url)
                }
            }
            
            if urls.isEmpty {
                urls = [""]
            }
            
            frontCardCreationDelegate?.frontCardCreation(with: FrontCardDataModel(birth: birthLabel.text ?? "",
                                                                                  cardName: cardTitleTextField.text ?? "",
                                                                                  userName: userNameTextField.text ?? "",
                                                                                  departmentName: nil,
                                                                                  mailAddress: nil,
                                                                                  mbti: nil,
                                                                                  phoneNumber: nil,
                                                                                  instagram: instagramID,
                                                                                  twitter: twitterID,
                                                                                  urls: urls,
                                                                                  defaultImageIndex: defaultImageIndex))
        }
    }
    static func nib() -> UINib {
        return UINib(nibName: FanFrontCardCreationCollectionViewCell.className, bundle: Bundle(for: FanFrontCardCreationCollectionViewCell.self))
    }
    
    // MARK: - @objc Methods
    
    @objc
    private func setBirthText(notification: NSNotification) {
        birthLabel.text = notification.object as? String
        birthLabel.textColor = .primary
        birthView.borderWidth = 0
        
        checkFrontCradStatus()
    }
    @objc
    private func setCardBackgroundImage(notifiation: NSNotification) {
        cardBackgroundImage = notifiation.object as? UIImage
        defaultImageIndex = 0
        backgroundSettingCollectionView.reloadData()
        
        checkFrontCradStatus()
    }
    @objc
    private func textFieldDidChange(_ notification: Notification) {
        if let textField = notification.object as? UITextField {
            switch textField {
            case cardTitleTextField:
                if let text = cardTitleTextField.text {
                    if text.count > maxLength {
                        let maxIndex = text.index(text.startIndex, offsetBy: maxLength)
                        let newString = String(text[text.startIndex..<maxIndex])
                        cardTitleTextField.text = newString
                    }
                }
            case userNameTextField:
                if let text = userNameTextField.text {
                    if text.count > maxLength {
                        let maxIndex = text.index(text.startIndex, offsetBy: maxLength)
                        let newString = String(text[text.startIndex..<maxIndex])
                        userNameTextField.text = newString
                    }
                }
            default:
                return
            }
        }
    }
    @objc
    private func touchBirthView() {
        _ = requiredTextFieldList.map { $0.resignFirstResponder() }
        _ = optionalTextFieldList.map { $0.resignFirstResponder() }
        
        NotificationCenter.default.post(name: .touchRequiredView, object: nil)
        
        presentingBirthBottomVCClosure?()
        birthView.layer.borderColor = UIColor.tertiary.cgColor
        birthView.layer.borderWidth = 1
    }
    @objc
    private func dismissBorderLine() {
        birthView.layer.borderWidth = 0
    }
    @objc
    private func cancelImagePicker() {
        if cardBackgroundImage == nil {
            backgroundSettingCollectionView.deselectItem(at: IndexPath.init(item: 0, section: 0), animated: true)
        }
    }
}

// MARK: - UICollectionViewDelegate

extension FanFrontCardCreationCollectionViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.item {
        case 0:
            NotificationCenter.default.post(name: .presentingImagePicker, object: nil)
            if cardBackgroundImage == nil {
                defaultImageIndex = nil
            } else {
                defaultImageIndex = 0
            }
        case 1: defaultImageIndex = 1
        case 2: defaultImageIndex = 2
        case 3: defaultImageIndex = 3
        case 4: defaultImageIndex = 4
        case 5: defaultImageIndex = 5
        case 6: defaultImageIndex = 6
        case 7: defaultImageIndex = 7
        default:
            return
        }
        checkFrontCradStatus()
        
        if let defaultImageIndex {
            if defaultImageIndex == 0 {
                Analytics.logEvent(Tracking.Event.touchFanCameraImage, parameters: nil)
            } else {
                Analytics.logEvent(Tracking.Event.touchFanDefaultImage,
                                   parameters: [
                                    "덕질_이미지_asn": defaultImageIndex
                                   ])
            }
        }
    }
}

// MARK: - UICollectionViewDataSource

extension FanFrontCardCreationCollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return backgroundList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Const.Xib.backgroundCollectionViewCell, for: indexPath) as? BackgroundCollectionViewCell else {
            return UICollectionViewCell()
        }
        switch indexPath.item {
        case 0:
            cell.initCell(image: cardBackgroundImage ?? UIImage(), isFirst: true)
        default:
            guard let image = UIImage(named: backgroundList[indexPath.item]) else { return UICollectionViewCell() }
            cell.initCell(image: image, isFirst: false)
        }
        
        if defaultImageIndex == 0 &&
           indexPath.item == 0 {
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .init())
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension FanFrontCardCreationCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 26, bottom: 0, right: 26)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CGFloat(60), height: CGFloat(60))
    }
}

// MARK: - UITextFieldDelegate

extension FanFrontCardCreationCollectionViewCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
            textField.borderWidth = 1
            textField.borderColor = .tertiary
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkFrontCradStatus()
        textField.resignFirstResponder()
        textField.borderWidth = 0
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}
