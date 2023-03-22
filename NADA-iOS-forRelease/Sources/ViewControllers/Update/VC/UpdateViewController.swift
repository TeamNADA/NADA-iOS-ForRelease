//
//  UpdateViewController.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2023/03/21.
//

import UIKit

import FlexLayout

class UpdateViewController: UIViewController {

    // MARK: - Components
    
    private let updateCardImageView = UIImageView()
    private let cancelButton = UIButton()
    private let updateContentLabel = UILabel()
    private let checkBoxButton = UIButton()
    private let checkLabel = UILabel()
    private let updateButton = UIButton()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        addTargets()
        setLayout()
    }
}

// MARK: - Extension

extension UpdateViewController {
    private func setUI() {
        view.backgroundColor = .black.withAlphaComponent(0.4)
        
        rootFlexContainer.backgroundColor = .background
        rootFlexContainer.layer.cornerRadius = 20
        
        updateCardImageView.image = UIImage(named: "imgUpdate")
        
        cancelButton.setImage(UIImage(named: "iconClear"), for: .normal)
        
        updateContentLabel.numberOfLines = 10
        updateContentLabel.font = .textRegular04
        updateContentLabel.textColor = .secondary
        updateContentLabel.text = ""
        
        checkBoxButton.setImage(UIImage(named: "icnCheckboxUnfilled"), for: .normal)
        checkBoxButton.setImage(UIImage(named: "icnCheckboxFilled"), for: .selected)
        
        checkLabel.font = .textRegular05
        checkLabel.textColor = .tertiary
        checkLabel.text = "확인했어요!"
        
        updateButton.setImage(UIImage(named: "btnMainGoUpdate"), for: .normal)
    }
    
    private func addTargets() {
        cancelButton.addTarget(self, action: #selector(touchCancelButton), for: .touchUpInside)
        updateButton.addTarget(self, action: #selector(touchUpdateButton), for: .touchUpInside)
    }
    
    // MARK: - Objc Methods
    
    @objc
    private func touchCancelButton() {
        // TODO: - 비강제 업데이트는 창 닫기. 강제 업데이트는 앱 종료.
    }
    
    @objc
    private func touchUpdateButton() {
        // TODO: - 앱스토어로 연결 혹은 홈으로 연결하는 액션 구현.
    }
}

// MARK: - Layout

extension UpdateViewController {
    private func setLayout() {
        
    }
}
