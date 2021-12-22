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
    
    // MARK: - @Functions
    // UI 세팅 작업
    private func setupUI() {
        view.addSubview(groupLabel)
        view.addSubview(cardView)
        view.addSubview(addButton)
        setupLayout()
        
        groupLabel.text = cardDataModel?.cardDescription
        setCardView()
    }
    
    private func setCardView() {
        cardView.backgroundImageView.updateServerImage(cardDataModel?.background ?? "")
        cardView.titleLabel.text = cardDataModel?.title ?? ""
        cardView.descriptionLabel.text = cardDataModel?.cardDescription ?? ""
        cardView.userNameLabel.text = cardDataModel?.name ?? ""
        cardView.birthLabel.text = cardDataModel?.birthDate ?? ""
        cardView.mbtiLabel.text = cardDataModel?.mbti ?? ""
        cardView.instagramIDLabel.text = cardDataModel?.instagram ?? ""
        cardView.lineURLLabel.text = cardDataModel?.link ?? ""
        
        if cardDataModel?.instagram == ""{
            cardView.instagramIcon.isHidden = true
        }
        if cardDataModel?.link == ""{
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
        let nextVC = SelectGroupBottomSheetViewController()
        nextVC.status = .add
        hideBottomSheetAndPresent(nextBottomSheet: nextVC, title: "그룹선택", height: 386)
    }

}
