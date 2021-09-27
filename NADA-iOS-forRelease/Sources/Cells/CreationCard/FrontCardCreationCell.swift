//
//  FrontCardCreationCell.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2021/09/24.
//

import UIKit

class FrontCardCreationCell: UICollectionViewCell {

    // MARK: - Properties
    
    static let identifier = "FrontCardCreationCell"
    private let backgroundList = ["addPhotoAlternateBlack24Dp1", "addPhotoAlternateBlack24Dp1", "addPhotoAlternateBlack24Dp1", "addPhotoAlternateBlack24Dp1", "addPhotoAlternateBlack24Dp1", "addPhotoAlternateBlack24Dp1"]
    private var requiredInfoList = [UITextField]()
    private var optionalInfoList = [UITextField]()
    
    // MARK: - @IBOutlet Properties
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var setBackgroundTextLabel: UILabel!
    @IBOutlet weak var requiredInfoTextLabel: UILabel!
    @IBOutlet weak var optionalInfoTextLabel: UILabel!
    
    @IBOutlet weak var cardBackgroundSettingCollectionView: UICollectionView!
    @IBOutlet weak var cardNameTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var birthTextField: UITextField!
    @IBOutlet weak var mbtiTextField: UITextField!
    @IBOutlet weak var instagramTextField: UITextField!
    @IBOutlet weak var linkNameTextField: UITextField!
    @IBOutlet weak var linkURLTextField: UITextField!
    @IBOutlet weak var clubNameTextField: UITextField!
    
    // MARK: - Cell Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUI()
        registerCell()
        setUITextFieldList()
        setNotificationTextField()
    }
}

// MARK: - Extensions

extension FrontCardCreationCell {
    private func setUI() {
//        scrollView.showsVerticalScrollIndicator = false
        
        let collectionViewLayout = cardBackgroundSettingCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
        collectionViewLayout?.scrollDirection = .horizontal
        
        setBackgroundTextLabel.text = "1 배경 지정"
        setBackgroundTextLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 16)
        requiredInfoTextLabel.text = "2 필수 정보"
        requiredInfoTextLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 16)
        optionalInfoTextLabel.text = "3 선택 정보"
        optionalInfoTextLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 16)
        
        cardNameTextField.placeholder = "명함 이름"
        userNameTextField.placeholder = "이름"
        birthTextField.placeholder = "생년월일"
        mbtiTextField.placeholder = "MBTI"
        
        instagramTextField.placeholder = "Instagram"
        linkNameTextField.placeholder = "링크 이름"
        linkURLTextField.placeholder = "링크"
        clubNameTextField.placeholder = "동아리 기수 / 파트"
        
        _ = requiredInfoList.map {
            $0.borderStyle = .none
            $0.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 16)
        }
        _ = optionalInfoList.map {
            $0.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 16)
        }
    }
    private func setUITextFieldList() {
        requiredInfoList.append(contentsOf: [cardNameTextField,
                                            userNameTextField,
                                            birthTextField,
                                            mbtiTextField])
        optionalInfoList.append(contentsOf: [instagramTextField,
                                            linkNameTextField,
                                            linkURLTextField,
                                            clubNameTextField])
    }
    private func registerCell() {
        cardBackgroundSettingCollectionView.delegate = self
        cardBackgroundSettingCollectionView.dataSource = self
        let cell = UINib(nibName: CardBackgroundSettingCell.identifier, bundle: nil)
        cardBackgroundSettingCollectionView.register(cell, forCellWithReuseIdentifier: CardBackgroundSettingCell.identifier)
    }
    private func setNotificationTextField() {

    }
}

// MARK: - UICollectionViewDelegate

extension FrontCardCreationCell: UICollectionViewDelegate {
    
}

// MARK: - UICollectionViewDataSource

extension FrontCardCreationCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return backgroundList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CardBackgroundSettingCell.identifier, for: indexPath) as? CardBackgroundSettingCell else {
            return UICollectionViewCell()
        }
        cell.initCell(image: backgroundList[indexPath.row])
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension FrontCardCreationCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 28, bottom: 0, right: 28)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.height
        let width = height
        
        return CGSize(width: width, height: height)
    }
}
