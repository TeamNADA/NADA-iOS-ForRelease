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
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var optionalInfoView: UIView!
    @IBOutlet weak var requiredInfoView: UIView!
    @IBOutlet weak var setBackgroundView: UIView!
    // MARK: - Cell Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUI()
        registerCell()
        setNotificationTextField()
    }
}

// MARK: - Extensions

extension FrontCardCreationCollectionViewCell {
    private func setUI() {
        initUITextFieldList()
//        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .black
        bgView.backgroundColor = .black
        setBackgroundView.backgroundColor = .gray
        requiredInfoView.backgroundColor = .gray
        optionalInfoView.backgroundColor = .gray
        cardBackgroundSettingCollectionView.backgroundColor = .gray
        
        let collectionViewLayout = cardBackgroundSettingCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
        collectionViewLayout?.scrollDirection = .horizontal
        
        setBackgroundTextLabel.text = "1 배경 지정"
        setBackgroundTextLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 16)
        setBackgroundTextLabel.textColor = .white
        
        requiredInfoTextLabel.text = "2 필수 정보"
        requiredInfoTextLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 16)
        requiredInfoTextLabel.textColor = .white
        
        optionalInfoTextLabel.text = "3 선택 정보"
        optionalInfoTextLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 16)
        optionalInfoTextLabel.textColor = .white
        
        cardNameTextField.attributedPlaceholder = NSAttributedString(string: "명함이름", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray5])
        userNameTextField.attributedPlaceholder = NSAttributedString(string: "이름", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray5])
        birthTextField.attributedPlaceholder = NSAttributedString(string: "생년월일", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray5])
        mbtiTextField.attributedPlaceholder = NSAttributedString(string: "MBTI", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray5])
        
        instagramTextField.attributedPlaceholder = NSAttributedString(string: "Instagram", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray5])
        linkNameTextField.attributedPlaceholder = NSAttributedString(string: "링크 이름", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray5])
        linkURLTextField.attributedPlaceholder = NSAttributedString(string: "링크", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray5])
        clubNameTextField.attributedPlaceholder = NSAttributedString(string: "동아리 기수 / 파트", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray5])
        
        _ = requiredInfoList.map {
            $0.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 16)
            $0.backgroundColor = .systemGray2
        }
        _ = optionalInfoList.map {
            $0.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 16)
            $0.backgroundColor = .systemGray2
        }
    }
    private func initUITextFieldList() {
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
        
        cardBackgroundSettingCollectionView.register(BackgroundCollectionViewCell.nib(), forCellWithReuseIdentifier: Const.Xib.backgroundCollectionViewCell)
    }
    private func setNotificationTextField() {

    }
    static func nib() -> UINib {
        return UINib(nibName: "FrontCardCreationCollectionViewCell", bundle: nil)
    }
}

// MARK: - UICollectionViewDelegate

extension FrontCardCreationCollectionViewCell: UICollectionViewDelegate {
    
}

// MARK: - UICollectionViewDataSource

extension FrontCardCreationCollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return backgroundList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Const.Xib.backgroundCollectionViewCell, for: indexPath) as? BackgroundCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.initCell(image: backgroundList[indexPath.row])
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension FrontCardCreationCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 28, bottom: 7, right: 28)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 18
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: CGFloat(60), height: CGFloat(60))
    }
}
