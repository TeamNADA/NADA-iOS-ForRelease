//
//  FrontCardCreationCell.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2021/09/24.
//

import UIKit

class FrontCardCreationCell: UICollectionViewCell {

    // MARK: - Properties
    private var requiredInfoList = [UITextField]()
    private var optionalInfoList = [UITextField]()
    
    // MARK: - @IBOutlet Properties
    
    @IBOutlet weak var setBackgroundTextLabel: UILabel!
    @IBOutlet weak var requiredInfoTextLabel: UILabel!
    @IBOutlet weak var optionalInfoTextLabel: UILabel!
    
    @IBOutlet weak var cardNameTextField: UITextField!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var birthTextField: UITextField!
    @IBOutlet weak var mbtiTextField: UITextField!
    @IBOutlet weak var instagramTextField: UITextField!
    @IBOutlet weak var linkNameTextField: UITextField!
    @IBOutlet weak var linkURLTextField: UITextField!
    @IBOutlet weak var clubNameTextField: UITextField!
    
    
    // MARK: - View Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUI()
        setUITextFieldList()
        setNotificationTextField()
    }
}

// MARK: - Extensions

extension FrontCardCreationCell {
    private func setUI() {
        setBackgroundTextLabel.text = "1 배경 지정"
        setBackgroundTextLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 16)
        requiredInfoTextLabel.text = "2 필수 정보"
        requiredInfoTextLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 16)
        optionalInfoTextLabel.text = "3 선택 정보"
        optionalInfoTextLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 16)
        
        cardNameTextField.placeholder = "명함 이름"
        userNameTextField.placeholder = "이름"
        birthTextField.placeholder = "생년월일"
        mbtiTextField.placeholder = "MBTI"
        
        instagramTextField.placeholder = "Instagram"
        linkNameTextField.placeholder = "링크 이름"
        linkURLTextField.placeholder = "링크"
        clubNameTextField.placeholder = "동아리 기수 / 파트"
        
        let _ = requiredInfoList.map {
            $0.borderStyle = .none
            $0.font = UIFont(name:  "AppleSDGothicNeo-Medium", size: 16)
        }
        let _ = optionalInfoList.map {
            $0.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 16)
        }
    }
    private func setUITextFieldList() {
        requiredInfoList.append(contentsOf: [cardNameTextField,
                                            userNameTextField,
                                            birthTextField,
                                            mbtiTextField])
        optionalInfoList.append(contentsOf: [instagramTextField,
                                            linkNameTextField,
                                            linkURLTextField,
                                            clubNameTextField])
    }
    private func setNotificationTextField() {

    }
}
