//
//  ReceiveCardBottomSheetViewController.swift
//  NADA-iOS-forRelease
//
//  Created by Yi Joon Choi on 2023/04/11.
//

import UIKit

import RxGesture
import SnapKit
import Then

class ReceiveCardBottomSheetViewController: CommonBottomSheetViewController {

    // MARK: - Properties
    
    // MARK: - UI Components
    
    private let byIdButton = UIButton().then {
        $0.backgroundColor = .button
        $0.setTitleColor(UIColor.tertiary, for: .normal)
        $0.setTitle("ID로 받기", for: .normal)
        $0.titleLabel?.font = .button01
        $0.layer.cornerRadius = 15
    }
    
    private let byQRButton = UIButton().then {
        $0.backgroundColor = .button
        $0.setTitleColor(UIColor.tertiary, for: .normal)
        $0.setTitle("QR로 받기", for: .normal)
        $0.titleLabel?.font = .button01
        $0.layer.cornerRadius = 15
    }
    
    private var stackview = UIStackView().then {
        $0.spacing = 12
        $0.distribution = .fillEqually
        $0.axis = .vertical
    }
    
    // MARK: - View Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
    }
    
}

extension ReceiveCardBottomSheetViewController {
    
    // MARK: - UI & Layout
    
    private func setLayout() {
        view.addSubview(stackview)
        stackview.addArrangedSubviews([byIdButton, byQRButton])
        stackview.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
            make.leading.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().offset(-54)
        }
    }
}
