//
//  GroupNameEditBottomSheetViewController.swift
//  NADA-iOS-forRelease
//
//  Created by 민 on 2021/12/11.
//

import UIKit
import IQKeyboardManagerSwift

class GroupNameEditBottomSheetViewController: CommonBottomSheetViewController, UITextFieldDelegate {

    // MARK: - Properties
    
    // 넘어온 그룹 이름 데이터를 받는 변수 선언
    var text: String = ""
    var returnToGroupEditViewController: (() -> Void)?
    var nowGroup: String?
    private var bottomSheetViewTopConstraint: NSLayoutConstraint?
    
    // 그룹 추가 텍스트 필드
    private let addGroupTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.cornerRadius = 10
        textField.backgroundColor = .textBox
        textField.attributedPlaceholder = NSAttributedString(string: "변경할 그룹명을 입력하세요.", attributes: [.foregroundColor: UIColor.quaternary, .font: UIFont.textRegular04])
        textField.returnKeyType = .done
        textField.setLeftPaddingPoints(12)
        textField.setRightPaddingPoints(12)
        
        return textField
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
        
        setupLayout()
        addGroupTextField.text = text
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
    }
    
    private func nowHideBottomSheetAndGoBack() {
        let safeAreaHeight = view.safeAreaLayoutGuide.layoutFrame.height
        let bottomPadding = view.safeAreaInsets.bottom
        bottomSheetViewTopConstraint?.constant = safeAreaHeight + bottomPadding
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
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
extension GroupNameEditBottomSheetViewController {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
//        groupEditWithAPI(groupRequest: GroupEditRequest(groupId: nowGroup?.cardGroupId ?? 0, groupName: addGroupTextField.text ?? ""))
        nowHideBottomSheetAndGoBack()
        
        return true
    }
}

// MARK: - Network
extension GroupNameEditBottomSheetViewController {
    func groupEditWithAPI(groupRequest: GroupEditRequest) {
        GroupAPI.shared.groupEdit(groupRequest: groupRequest) { response in
            switch response {
            case .success:
                print("groupEditWithAPI - success")
            case .requestErr(let message):
                print("groupEditWithAPI - requestErr: \(message)")
            case .pathErr:
                print("groupEditWithAPI - pathErr")
            case .serverErr:
                print("groupEditWithAPI - serverErr")
            case .networkFail:
                print("groupEditWithAPI - networkFail")
            }
        }
    }
}
