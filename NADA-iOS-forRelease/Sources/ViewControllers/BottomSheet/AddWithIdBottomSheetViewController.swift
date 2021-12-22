//
//  AddWithIdBottomSheetViewController.swift
//  NADA-iOS-forRelease
//
//  Created by Yi Joon Choi on 2021/11/25.
//

import UIKit
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
        label.text = "검색한 ID가 존재하지 않습니다."
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
}

extension AddWithIdBottomSheetViewController {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        // 서버 연결과 더불어... 검색 결과가 없으면 bottomsheet dismiss 하지 말고 hidden 풀어주기
        cardDetailFetchWithAPI(cardID: textField.text ?? "")
        return true
    }
}

extension AddWithIdBottomSheetViewController {
    func cardDetailFetchWithAPI(cardID: String) {
        CardAPI.shared.cardDetailFetch(cardID: cardID) { response in
            switch response {
            case .success(let data):
                if let card = data as? CardClass {
                    let nextVC = CardResultBottomSheetViewController()
                    nextVC.cardDataModel = Card(cardID: card.card.cardID,
                                                background: card.card.background,
                                                title: card.card.title,
                                                name: card.card.name,
                                                birthDate: card.card.birthDate,
                                                mbti: card.card.mbti,
                                                instagram: card.card.instagram,
                                                link: card.card.link,
                                                cardDescription: card.card.cardDescription,
                                                isMincho: card.card.isMincho,
                                                isSoju: card.card.isSoju,
                                                isBoomuk: card.card.isBoomuk,
                                                isSauced: card.card.isSauced,
                                                oneTmi: card.card.oneTmi,
                                                twoTmi: card.card.twoTmi,
                                                threeTmi: card.card.threeTmi)
                    self.hideBottomSheetAndPresent(nextBottomSheet: nextVC, title: card.card.name, height: 574)
                }
            case .requestErr(let message):
                print("cardDetailFetchWithAPI - requestErr: \(message)")
                self.errorImageView.isHidden = false
                self.explainLabel.isHidden = false
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

