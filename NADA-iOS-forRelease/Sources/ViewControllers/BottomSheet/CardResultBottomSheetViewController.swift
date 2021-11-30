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
    private let groupLabel: UILabel = {
        let label = UILabel()
        label.text = "어쩌구 동아리 명함"
        label.textColor = .secondary
        label.font = .textRegular03
        
        return label
    }()
    
    private let cardView: UIView = {
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
            addButton.centerXAnchor.constraint(equalTo: bottomSheetView.centerXAnchor)
        ])
    }
    
    @objc func presentGroupSelectBottomSheet() {
        hideBottomSheetAndPresent(nextBottomSheet: SelectGroupBottomSheetViewController(), title: "그룹선택", height: 386)
        print("next bottomsheet")
    }

}
