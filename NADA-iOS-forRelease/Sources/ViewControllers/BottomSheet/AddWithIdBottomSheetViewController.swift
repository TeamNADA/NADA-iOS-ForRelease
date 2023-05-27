//
//  AddWithIdBottomSheetViewController.swift
//  NADA-iOS-forRelease
//
//  Created by Yi Joon Choi on 2021/11/25.
//

import UIKit

import FirebaseAnalytics
import IQKeyboardManagerSwift

class AddWithIdBottomSheetViewController: CommonBottomSheetViewController, UITextFieldDelegate {

    // MARK: - Properties
    // ID 추가 텍스트 필드
    private let addWithIdTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.cornerRadius = 10
        textField.backgroundColor = .textBox
        textField.attributedPlaceholder = NSAttributedString(string: "친구의 명함 ID를 입력해보세요.", attributes: [.foregroundColor: UIColor.quaternary, .font: UIFont.textRegular04])
        textField.returnKeyType = .done
        textField.setLeftPaddingPoints(12)
        textField.setRightPaddingPoints(12)
        
        return textField
    }()
    
    private let errorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "iconError")
        
        return imageView
    }()
    
    private let explainLabel: UILabel = {
        let label = UILabel()
        label.textColor = .stateColorError
        label.font = .textRegular05
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        addWithIdTextField.delegate = self
        IQKeyboardManager.shared.shouldResignOnTouchOutside = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setTracking()
        self.addWithIdTextField.becomeFirstResponder()
    }
    
    // MARK: - @Functions
    // UI 세팅 작업
    private func setupUI() {
        view.addSubview(addWithIdTextField)
        view.addSubview(errorImageView)
        view.addSubview(explainLabel)
        
        setupLayout()
        errorImageView.isHidden = true
        explainLabel.isHidden = true
    }
    
    // 레이아웃 세팅
    private func setupLayout() {
        addWithIdTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addWithIdTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            addWithIdTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            addWithIdTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            addWithIdTextField.heightAnchor.constraint(equalToConstant: 45)
        ])
        
        errorImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            errorImageView.topAnchor.constraint(equalTo: addWithIdTextField.bottomAnchor, constant: 7),
            errorImageView.leadingAnchor.constraint(equalTo: addWithIdTextField.leadingAnchor, constant: 4),
            errorImageView.widthAnchor.constraint(equalToConstant: 16),
            errorImageView.heightAnchor.constraint(equalToConstant: 16)
        ])
        
        explainLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            explainLabel.topAnchor.constraint(equalTo: addWithIdTextField.bottomAnchor, constant: 8),
            explainLabel.leadingAnchor.constraint(equalTo: errorImageView.trailingAnchor, constant: 5)
        ])
    }
    
    private func setTracking() {
        Analytics.logEvent(AnalyticsEventScreenView,
                           parameters: [
                            AnalyticsParameterScreenName: Tracking.Screen.addByIdBottomSheet
                           ])
    }
}

extension AddWithIdBottomSheetViewController {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        cardDetailFetchWithAPI(cardUUID: textField.text ?? "")
        return true
    }
}

extension AddWithIdBottomSheetViewController {
    func cardDetailFetchWithAPI(cardUUID: String) {
        CardAPI.shared.cardDetailFetch(cardUUID: cardUUID) { response in
            switch response {
            case .success(let data):
                if let card = data as? Card {
                    // TODO: - 자신의 명함 추가하는 경우 예외처리.
//                    if UserDefaults.standard.string(forKey: Const.UserDefaultsKey.userID) == card.author {
//                        self.errorImageView.isHidden = false
//                        self.explainLabel.isHidden = false
//                        self.explainLabel.text = "자신의 명함은 추가할 수 없습니다."
//                    } else {
                        self.addWithIdTextField.resignFirstResponder()
                        let nextVC = CardResultBottomSheetViewController()
                        nextVC.cardDataModel = card
                        self.hideBottomSheetAndPresent(nextBottomSheet: nextVC, title: card.userName, height: 574)
//                    }
                }
            case .requestErr(let message):
                print("cardDetailFetchWithAPI - requestErr: \(message)")
                self.errorImageView.isHidden = false
                self.explainLabel.isHidden = false
                self.explainLabel.text = "검색한 ID가 존재하지 않습니다."
            case .pathErr:
                print("cardDetailFetchWithAPI - pathErr")
            case .serverErr:
                print("cardDetailFetchWithAPI - serverErr")
            case .networkFail:
                print("cardDetailFetchWithAPI - networkFail")
            }
        }
    }
}
