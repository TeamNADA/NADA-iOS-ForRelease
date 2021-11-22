//
//  AddGroupBottomSheetViewController.swift
//  NADA-iOS-forRelease
//
//  Created by 민 on 2021/11/21.
//

import UIKit

class AddGroupBottomSheetViewController: CommonBottomSheetViewController {

    // MARK: - Properties
    // 그룹 추가 텍스트 필드
    private let addGroupTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "  추가할 그룹명을 입력하세요."
        textField.borderStyle = .none
        textField.cornerRadius = 10
        textField.backgroundColor = .textBox
        textField.attributedPlaceholder = NSAttributedString(string: "   추가할 그룹명을 입력하세요.", attributes: [.foregroundColor: UIColor.quaternary, .font: UIFont.textRegular04])
        textField.returnKeyType = .done
        
        return textField
    }()
    
    private let checkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "iconDone")
        
        return imageView
    }()
    
    private let explainLabel: UILabel = {
        let label = UILabel()
        label.text = "새로운 그룹은 최대 4개까지만 등록 가능합니다."
        label.textColor = .mainColorButtonText
        label.font = .textRegular05

        return label
    }()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setupUI()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        self.addGroupTextField.becomeFirstResponder()
//    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.addGroupTextField.becomeFirstResponder()
    }

    // MARK: - @Functions
    // UI 세팅 작업
    private func setupUI() {
        view.addSubview(addGroupTextField)
        view.addSubview(checkImageView)
        view.addSubview(explainLabel)
        
        setupLayout()
    }
    
    // 레이아웃 세팅
    private func setupLayout() {
        addGroupTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addGroupTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            addGroupTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            addGroupTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            addGroupTextField.heightAnchor.constraint(equalToConstant: 45)
        ])
        
        checkImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            checkImageView.topAnchor.constraint(equalTo: addGroupTextField.bottomAnchor, constant: 7),
            checkImageView.leadingAnchor.constraint(equalTo: addGroupTextField.leadingAnchor, constant: 4),
            checkImageView.widthAnchor.constraint(equalToConstant: 16),
            checkImageView.heightAnchor.constraint(equalToConstant: 16)
        ])
        
        explainLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            explainLabel.topAnchor.constraint(equalTo: addGroupTextField.bottomAnchor, constant: 8),
            explainLabel.leadingAnchor.constraint(equalTo: checkImageView.trailingAnchor, constant: 5)
        ])
    }
}
