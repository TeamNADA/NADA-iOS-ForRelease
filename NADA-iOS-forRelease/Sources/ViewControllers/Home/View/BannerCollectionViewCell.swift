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
    
    // MARK: - UI Components
    private var bannerURL: String?
    
    // MARK: - UI Components
    
    private let stackview = UIStackView().then {
        $0.distribution = .fill
        $0.axis = .horizontal
    }
    
    private let bannerTitleBackView = UIView().then {
        $0.backgroundColor = .mainColorNadaMain.withAlphaComponent(0.3)
        $0.layer.cornerRadius = 12
    }
    
    private var bannerTitleLabel = UILabel().then {
        $0.font = .textBold03
        $0.textColor = .mainColorNadaMain
        $0.text = "Label"
    }
    
    private var bannerTextLabel = UILabel().then {
        $0.font = .textRegular04
        $0.text = "Placeholder text"
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
        
        bannerTextLabel.text = ""
        bannerTextLabel.text = ""
    }
    
    // MARK: - Methods
    
    public func setData(_ model: BannerResponse) {
        bannerTitleLabel.text = model.label
        bannerTextLabel.text = model.text
        bannerURL = model.url
    }
    
    // MARK: - UI & Layout
    
    private func setUI() {
        self.backgroundColor = .background
    }
    
    private func setLayout() {
        bannerTitleBackView.addSubview(bannerTitleLabel)
        stackview.addSubviews([bannerTitleBackView, bannerTextLabel])
        self.addSubview(stackview)
        
        bannerTitleLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.top.equalToSuperview().inset(5)
            make.leading.equalToSuperview().inset(8)
        }
        stackview.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.top.leading.equalToSuperview().inset(8)
            make.trailing.equalToSuperview()
        }
        bannerTitleBackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.top.leading.equalToSuperview()
        }
        bannerTextLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(bannerTitleBackView.snp.trailing).offset(8)
        }
    }
    
}
