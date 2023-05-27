//
//  CardResultBottomSheetViewController.swift
//  NADA-iOS-forRelease
//
//  Created by Yi Joon Choi on 2021/11/26.
//

import UIKit

import FirebaseAnalytics
import IQKeyboardManagerSwift
import Then

class CardResultBottomSheetViewController: CommonBottomSheetViewController {

    // MARK: - Properties
    var cardDataModel: Card?
    
    var status: Status = .add
    
    private let groupLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondary
        label.font = .textRegular03
        
        return label
    }()
    
    private let cardViewCollevctionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.estimatedItemSize = .zero
    }
    
    private lazy var cardViewCollevctionView = UICollectionView(frame: .zero, collectionViewLayout: cardViewCollevctionViewFlowLayout).then {
        $0.showsHorizontalScrollIndicator = false
        $0.clipsToBounds = false
        $0.isScrollEnabled = false
    }
    
    private let addButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "btnMainAdd"), for: .normal)
        button.addTarget(self, action: #selector(presentGroupSelectBottomSheet), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        registerCell()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setTracking()
    }
    
    override func hideBottomSheetAndGoBack() {
        super.hideBottomSheetAndGoBack()
        
        NotificationCenter.default.post(name: .dismissQRCodeCardResult, object: nil)
    }
    
    // MARK: - @Functions
    // UI 세팅 작업
    private func setupUI() {
        view.addSubview(groupLabel)
        view.addSubview(cardViewCollevctionView)
        view.addSubview(addButton)
        setupLayout()
        
        groupLabel.text = cardDataModel?.departmentName
//        setCardView()
    }
    
    private func setTracking() {
        Analytics.logEvent(AnalyticsEventScreenView,
                           parameters: [
                            AnalyticsParameterScreenName: Tracking.Screen.cardResultBottomSheet
                           ])
    }
    
//    private func setCardView() {
//        guard let cardDataModel else { return }
//
//        cardView.backgroundImageView.updateServerImage(cardDataModel.cardImage)
//        cardView.titleLabel.text = cardDataModel.cardName
//        cardView.descriptionLabel.text = cardDataModel.departmentName ?? ""
//        cardView.userNameLabel.text = cardDataModel.userName
//        cardView.birthLabel.text = cardDataModel.birth
//        cardView.mbtiLabel.text = cardDataModel.mbti ?? ""
//        cardView.instagramIDLabel.text = cardDataModel.instagram ?? ""
//        if let urls = cardDataModel.urls {
//            cardView.lineURLLabel.text = urls[0]
//        }
//
//        if cardDataModel.instagram == nil {
//            cardView.instagramIcon.isHidden = true
//        }
//        if cardDataModel.urls == nil {
//            cardView.urlIcon.isHidden = true
//        }
//    }
    
    // 레이아웃 세팅
    private func setupLayout() {
        groupLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            groupLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 14),
            groupLabel.centerXAnchor.constraint(equalTo: bottomSheetView.centerXAnchor)
        ])
        
        cardViewCollevctionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cardViewCollevctionView.topAnchor.constraint(equalTo: groupLabel.bottomAnchor, constant: 20),
            cardViewCollevctionView.centerXAnchor.constraint(equalTo: bottomSheetView.centerXAnchor),
            cardViewCollevctionView.widthAnchor.constraint(equalToConstant: 201),
            cardViewCollevctionView.heightAnchor.constraint(equalToConstant: 332)
        ])
        
        addButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: cardViewCollevctionView.bottomAnchor, constant: 30),
            addButton.centerXAnchor.constraint(equalTo: bottomSheetView.centerXAnchor),
            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }
    
    private func registerCell() {
        cardViewCollevctionView.delegate = self
        cardViewCollevctionView.dataSource = self
         
        cardViewCollevctionView.register(FrontCardCell.nib(), forCellWithReuseIdentifier: FrontCardCell.className)
        cardViewCollevctionView.register(FanFrontCardCell.nib(), forCellWithReuseIdentifier: FanFrontCardCell.className)
        cardViewCollevctionView.register(CompanyFrontCardCell.nib(), forCellWithReuseIdentifier: CompanyFrontCardCell.className)
    }
    
    @objc func presentGroupSelectBottomSheet() {
        Analytics.logEvent(Tracking.Event.touchAddCard, parameters: nil)
        groupListFetchWithAPI()
    }

}

// MARK: - UICollectionViewDelegate
extension CardResultBottomSheetViewController: UICollectionViewDelegate {
    
}

// MARK: - UICollectionViewDataSource
extension CardResultBottomSheetViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let frontCard = cardDataModel else { return UICollectionViewCell() }
        switch frontCard.cardType {
        case "BASIC":
            guard let cardCell = collectionView.dequeueReusableCell(withReuseIdentifier: FrontCardCell.className, for: indexPath) as? FrontCardCell else {
                return UICollectionViewCell()
            }
            cardCell.initCellFromServer(cardData: frontCard, isShareable: false)
            cardCell.setConstraints()
            return cardCell
        case "FAN":
            guard let cardCell = collectionView.dequeueReusableCell(withReuseIdentifier: FanFrontCardCell.className, for: indexPath) as? FanFrontCardCell else {
                return UICollectionViewCell()
            }
            cardCell.initCellFromServer(cardData: frontCard, isShareable: false)
            cardCell.setConstraints()
            return cardCell
        case "COMPANY":
            guard let cardCell = collectionView.dequeueReusableCell(withReuseIdentifier: CompanyFrontCardCell.className, for: indexPath) as? CompanyFrontCardCell else {
                return UICollectionViewCell()
            }
            cardCell.initCellFromServer(cardData: frontCard, isShareable: false)
            cardCell.setConstraints()
            return cardCell
        default:
            return UICollectionViewCell()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension CardResultBottomSheetViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 201, height: 332)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
}
    
extension CardResultBottomSheetViewController {
    func groupListFetchWithAPI() {
        GroupAPI.shared.groupListFetch { response in
            switch response {
            case .success(let data):
                if let groups = data as? [String] {
                    let nextVC = SelectGroupBottomSheetViewController()
                    nextVC.status = self.status
                    nextVC.cardDataModel = self.cardDataModel
                    nextVC.serverGroups = groups
                    self.hideBottomSheetAndPresent(nextBottomSheet: nextVC, title: "그룹선택", height: 386)
                }
            case .requestErr(let message):
                print("groupListFetchWithAPI - requestErr: \(message)")
            case .pathErr:
                print("groupListFetchWithAPI - pathErr")
            case .serverErr:
                print("groupListFetchWithAPI - serverErr")
            case .networkFail:
                print("groupListFetchWithAPI - networkFail")
            }
        }
    }
}
