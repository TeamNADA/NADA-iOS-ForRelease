//
//  BannerCollectionViewCell.swift
//  NADA-iOS-forRelease
//
//  Created by Yi Joon Choi on 2023/08/22.
//

import UIKit

import SnapKit
import Then

class BannerCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    // MARK: - UI Components
    
    private var bannerTitleLabel = UILabel().then {
        $0.font = .textBold03
        $0.backgroundColor = .mainColorNadaMain.withAlphaComponent(0.3)
        $0.textColor = .mainColorNadaMain
    }
    
    private var bannerTextLabel = UILabel().then {
        $0.font = .textRegular04
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
    
//    public func setData(_ model: AroundMeResponse) {
//        profileImageView.updateServerImage(model.imageURL)
//        myNameLabel.text = model.name
//        cardNameLabel.text = model.cardName
//        cardUUID = model.cardUUID
//    }
    
    // MARK: - UI & Layout
    
    private func setUI() {
        self.backgroundColor = .background
    }
    
    private func setLayout() {
        self.addSubviews([bannerTitleLabel, bannerTextLabel])
        
        bannerTitleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(8)
            make.trailing.equalTo(bannerTextLabel.snp.leading).offset(8)
        }
        bannerTextLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
        }
    }
    
}
