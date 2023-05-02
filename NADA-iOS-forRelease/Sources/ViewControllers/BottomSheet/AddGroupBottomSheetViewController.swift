//
//  AddGroupBottomSheetViewController.swift
//  NADA-iOS-forRelease
//
//  Created by 민 on 2021/11/21.
//

import UIKit
import IQKeyboardManagerSwift

class AddGroupBottomSheetViewController: CommonBottomSheetViewController, UITextFieldDelegate {
    
    // MARK: - Properties
    var returnToGroupEditViewController: (() -> Void)?
    private var bottomSheetViewTopConstraint: NSLayoutConstraint?

    // 그룹 추가 텍스트 필드
    private let addGroupTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.cornerRadius = 10
        textField.backgroundColor = .textBox
        textField.attributedPlaceholder = NSAttributedString(string: "추가할 그룹명을 입력하세요.", attributes: [.foregroundColor: UIColor.quaternary, .font: UIFont.textRegular04])
        textField.returnKeyType = .done
        textField.setLeftPaddingPoints(12)
        textField.setRightPaddingPoints(12)
        
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
        addGroupTextField.delegate = self
        IQKeyboardManager.shared.shouldResignOnTouchOutside = false
    }
    
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
    
    private func nowHideBottomSheetAndGoBack() {
        let safeAreaHeight = view.safeAreaLayoutGuide.layoutFrame.height
        let bottomPadding = view.safeAreaInsets.bottom
        bottomSheetViewTopConstraint?.constant = safeAreaHeight + bottomPadding
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            self.dimmedBackView.alpha = 0.0
            self.view.layoutIfNeeded()
            self.bottomSheetCoverView.isHidden = false
        }, completion: { _ in
            if self.presentingViewController != nil {
                self.dismiss(animated: false) {
                    self.returnToGroupEditViewController?()
                }
            }
        })
    }
}

// MARK: - Extensions
extension AddGroupBottomSheetViewController {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        groupAddWithAPI(groupRequest: GroupAddRequest(cardGroupName: addGroupTextField.text ?? ""))
        
        return true
    }
}

// MARK: - Network
extension AddGroupBottomSheetViewController {
    func groupAddWithAPI(groupRequest: GroupAddRequest) {
        GroupAPI.shared.groupAdd(groupRequest: groupRequest) { response in
            switch response {
            case .success:
                print("groupAddWithAPI - success")
                self.addGroupTextField.becomeFirstResponder()
                self.nowHideBottomSheetAndGoBack()
            case .requestErr(let message):
                print("groupAddWithAPI - requestErr: \(message)")
                self.makeOKAlert(title: "", message: "이미 존재하는 그룹명입니다.")
            case .pathErr:
                print("groupAddWithAPI - pathErr")
            case .serverErr:
                print("groupAddWithAPI - serverErr")
            case .networkFail:
                print("groupAddWithAPI - networkFail")
            }
        }
    }
}
