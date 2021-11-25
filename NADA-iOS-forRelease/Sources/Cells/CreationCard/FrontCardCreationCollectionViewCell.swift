//
//  FrontCardCreationCell.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2021/09/24.
//

import UIKit

class FrontCardCreationCollectionViewCell: UICollectionViewCell {

    // MARK: - Properties
    
    private let backgroundList = ["img", "img", "img", "img", "img", "img"]
    private var requiredTextFieldList = [UITextField]()
    private var optionalTextFieldList = [UITextField]()
    public weak var frontCardCreationDelegate: FrontCardCreationDelegate?
    
    // MARK: - @IBOutlet Properties
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var setBackgroundTextLabel: UILabel!
    @IBOutlet weak var cardTitleInfoTextLabel: UILabel!
    @IBOutlet weak var requiredInfoTextLabel: UILabel!
    @IBOutlet weak var optionalInfoTextLabel: UILabel!
    
    @IBOutlet weak var backgroundSettingCollectionView: UICollectionView!
    @IBOutlet weak var cardTitleTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var birthTextField: UITextField!
    @IBOutlet weak var mbtiTextField: UITextField!
    @IBOutlet weak var instagramIDTextField: UITextField!
    @IBOutlet weak var linkURLTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    @IBOutlet weak var bgView: UIView!
    
    // MARK: - Cell Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUI()
        registerCell()
        textFieldDelegate()
    }
}

// MARK: - Extensions
extension FrontCardCreationCollectionViewCell {
    private func setUI() {
        initUITextFieldList()
        backgroundSettingCollectionView.showsHorizontalScrollIndicator = false
        scrollView.indicatorStyle = .default
         scrollView.backgroundColor = .primary
         bgView.backgroundColor = .primary
         backgroundSettingCollectionView.backgroundColor = .primary
        
        let collectionViewLayout = backgroundSettingCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
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
        
        let requiredAttributeString = NSMutableAttributedString(string: "*나에 대한 기본정보를 입력해 주세요.")
        requiredAttributeString.addAttribute(.foregroundColor, value: UIColor.mainColorNadaMain, range: NSRange(location: 0, length: 1))
        requiredAttributeString.addAttribute(.foregroundColor, value: UIColor.secondary, range: NSRange(location: 1, length: requiredAttributeString.length - 1))
        requiredInfoTextLabel.attributedText = requiredAttributeString
        requiredInfoTextLabel.font = .textBold01
        
        optionalInfoTextLabel.text = "나를 더 표현할 수 있는 정보가 있나요?"
        optionalInfoTextLabel.font = .textBold01
        optionalInfoTextLabel.textColor = .secondary
        
        cardTitleTextField.attributedPlaceholder = NSAttributedString(string: "명함 이름 (15자)", attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.quaternary
        ])
         userNameTextField.attributedPlaceholder = NSAttributedString(string: "본인 이름 (15자)", attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.quaternary
        ])
         birthTextField.attributedPlaceholder = NSAttributedString(string: "생년월일", attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.quaternary
        ])
         mbtiTextField.attributedPlaceholder = NSAttributedString(string: "MBTI", attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.quaternary
        ])
        
        instagramIDTextField.attributedPlaceholder = NSAttributedString(string: "Instagram", attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.quaternary
        ])
        linkURLTextField.attributedPlaceholder = NSAttributedString(string: "URL (Github, Blog)", attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.quaternary
        ])
        descriptionTextField.attributedPlaceholder = NSAttributedString(string: "동아리 기수 / 파트 (15자)", attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.quaternary
        ])
        
        _ = requiredTextFieldList.map {
            $0.font = .textRegular04
            $0.backgroundColor = .textBox
            $0.textColor = .primary
            $0.layer.cornerRadius = 10
            $0.borderStyle = .none
            $0.addLeftPadding()
        }
        _ = optionalTextFieldList.map {
            $0.font = .textRegular04
            $0.backgroundColor = .textBox
            $0.textColor = .primary
            $0.layer.cornerRadius = 10
            $0.borderStyle = .none
            $0.addLeftPadding()
        }
    }
    private func initUITextFieldList() {
        requiredTextFieldList.append(contentsOf: [
            cardTitleTextField,
            userNameTextField,
            birthTextField,
            mbtiTextField
        ])
        optionalTextFieldList.append(contentsOf: [
            instagramIDTextField,
            linkURLTextField,
            descriptionTextField
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
    static func nib() -> UINib {
        return UINib(nibName: Const.Xib.frontCardCreationCollectionViewCell, bundle: Bundle(for: FrontCardCreationCollectionViewCell.self))
    }
}

// MARK: - UICollectionViewDelegate
extension FrontCardCreationCollectionViewCell: UICollectionViewDelegate { }

// MARK: - UICollectionViewDataSource
extension FrontCardCreationCollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return backgroundList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Const.Xib.backgroundCollectionViewCell, for: indexPath) as? BackgroundCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.initCell(image: backgroundList[indexPath.item])
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension FrontCardCreationCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 26, bottom: 0, right: 26)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CGFloat(60), height: CGFloat(60))
    }
}

// MARK: - UITextFieldDelegate
extension FrontCardCreationCollectionViewCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.borderWidth = 1
        textField.becomeFirstResponder()
        textField.borderColor = .tertiary
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if cardTitleTextField.hasText && userNameTextField.hasText && birthTextField.hasText && mbtiTextField.hasText {
            frontCardCreationDelegate?.frontCardCreation(requiredInfo: true)
            frontCardCreationDelegate?.frontCardCreation(withRequired: [
                "defaultImage": String(0),
                "title": cardTitleTextField.text ?? "",
                "name": userNameTextField.text ?? "",
                "birthDate": birthTextField.text ?? "",
                "mbti": mbtiTextField.text ?? ""
            ], withOptional: [
                "instagram": instagramIDTextField.text ?? "",
                "linkURL": linkURLTextField.text ?? "",
                "description": descriptionTextField.text ?? ""
            ])
        } else {
            frontCardCreationDelegate?.frontCardCreation(requiredInfo: false)
        }
        textField.borderWidth = 0
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}
