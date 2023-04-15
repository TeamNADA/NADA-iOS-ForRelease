//
//  CardResultBottomSheetViewController.swift
//  NADA-iOS-forRelease
//
//  Created by Yi Joon Choi on 2021/11/26.
//

import UIKit
import IQKeyboardManagerSwift

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
    
    private let cardView: CardView = {
        let view = CardView()
        return view
    }()
    
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
    }
    
    override func hideBottomSheetAndGoBack() {
        super.hideBottomSheetAndGoBack()
        
        NotificationCenter.default.post(name: .dismissQRCodeCardResult, object: nil)
    }
    
    // MARK: - @Functions
    // UI 세팅 작업
    private func setupUI() {
        view.addSubview(groupLabel)
        view.addSubview(cardView)
        view.addSubview(addButton)
        setupLayout()
        
        groupLabel.text = cardDataModel?.departmentName
        setCardView()
    }
    
    private func setCardView() {
        guard let cardDataModel else { return }
        
        cardView.backgroundImageView.updateServerImage(cardDataModel.cardImage)
        cardView.titleLabel.text = cardDataModel.cardName
        cardView.descriptionLabel.text = cardDataModel.departmentName ?? ""
        cardView.userNameLabel.text = cardDataModel.userName
        cardView.birthLabel.text = cardDataModel.birth
        cardView.mbtiLabel.text = cardDataModel.mbti ?? ""
        cardView.instagramIDLabel.text = cardDataModel.instagram ?? ""
        if let urls = cardDataModel.urls {
            cardView.lineURLLabel.text = urls[0]
        }
        
        if cardDataModel.instagram == nil {
            cardView.instagramIcon.isHidden = true
        }
        if cardDataModel.urls == nil {
            cardView.urlIcon.isHidden = true
        }
    }
    
    // 레이아웃 세팅
    private func setupLayout() {
        groupLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            groupLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 14),
            groupLabel.centerXAnchor.constraint(equalTo: bottomSheetView.centerXAnchor)
        ])
        
        cardView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: groupLabel.bottomAnchor, constant: 20),
            cardView.centerXAnchor.constraint(equalTo: bottomSheetView.centerXAnchor),
            cardView.widthAnchor.constraint(equalToConstant: 201),
            cardView.heightAnchor.constraint(equalToConstant: 332)
        ])
        
        addButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 30),
            addButton.centerXAnchor.constraint(equalTo: bottomSheetView.centerXAnchor),
            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }
    
    @objc func presentGroupSelectBottomSheet() {
        groupListFetchWithAPI(userID: UserDefaults.standard.string(forKey: Const.UserDefaultsKey.userID) ?? "")
    }

}

extension CardResultBottomSheetViewController {
    func groupListFetchWithAPI(userID: String) {
        GroupAPI.shared.groupListFetch(userID: userID) { response in
            switch response {
            case .success(let data):
                if let group = data as? Groups {
                    let nextVC = SelectGroupBottomSheetViewController()
                    nextVC.status = self.status
                    nextVC.cardDataModel = self.cardDataModel
                    nextVC.serverGroups = group
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
