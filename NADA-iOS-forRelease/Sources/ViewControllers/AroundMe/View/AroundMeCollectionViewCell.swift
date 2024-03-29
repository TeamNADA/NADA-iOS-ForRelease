//
//  AroundMeCollectionViewCell.swift
//  NADA-iOS-forRelease
//
//  Created by Yi Joon Choi on 2023/03/11.
//

import SnapKit
import Then
import UIKit

class AroundMeCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var cardUUID: String = ""
    var addCardMethod: (() -> Void)?
    
    // MARK: - UI Components
    
    private let plusButton = UIButton().then {
        $0.setImage(UIImage(named: "icnPlusCircle"), for: .normal)
        $0.addTarget(self, action: #selector(touchPlusButton), for: .touchUpInside)
    }
    
    private var profileImageView = UIImageView().then {
        $0.image = UIImage(named: "imgProfileSmall")
        $0.layer.cornerRadius = 33
        $0.clipsToBounds = true
    }
    
    private var myNameLabel = UILabel().then {
        $0.font = .textBold01
    }
    
    private let dividerLine = UIView().then {
        $0.backgroundColor = .quaternary
    }
    
    private var cardNameLabel = UILabel().then {
        $0.textColor = .tertiary
        $0.font = .textBold02
    }
    
    // MARK: - Initialize
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    // MARK: - Methods
    
    public func setData(_ model: AroundMeResponse) {
        profileImageView.updateServerImage(model.imageURL)
        myNameLabel.text = model.name
        cardNameLabel.text = model.cardName
        cardUUID = model.cardUUID
    }
    
    // MARK: - UI & Layout
    
    private func setUI() {
        self.backgroundColor = .button
        self.layer.cornerRadius = 15
    }
    
    private func setLayout() {
        self.addSubviews([plusButton, profileImageView, myNameLabel,
                          dividerLine, cardNameLabel])
        
        plusButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(12)
        }
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.leading.equalToSuperview().inset(12)
            make.width.height.equalTo(66)
        }
        myNameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(profileImageView.snp.centerY)
            make.leading.equalTo(profileImageView.snp.trailing).offset(10)
        }
        cardNameLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(10)
            make.leading.equalToSuperview().inset(20)
        }
        dividerLine.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview()
            make.bottom.equalTo(cardNameLabel.snp.top).offset(-11)
            make.height.equalTo(1)
        }
    }
    
    // MARK: - @objc
    
    @objc
    private func touchPlusButton() {
        addCardMethod?()
    }
    
}
