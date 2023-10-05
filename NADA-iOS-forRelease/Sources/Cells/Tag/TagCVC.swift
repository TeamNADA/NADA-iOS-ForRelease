//
//  TagCVC.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2023/09/25.
//

import UIKit

import SnapKit

class TagCVC: UICollectionViewCell {
    
    // MARK: - Components
    
    private let bgView = UIView()
    private let tagImageView = UIImageView()
    private let tagLabel = UILabel()
    private let selectedBgView = UIView()
    private let checkImageView = UIImageView()

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setUI()
        setLayout()
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setUI()
        setLayout()
    }
    
    override var isSelected: Bool {
        didSet {
            selectedBgView.isHidden = isSelected ? false : true
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        tagLabel.text = ""
        tagImageView.image = UIImage()
    }
}

// MARK: - Initialize

extension TagCVC {
    func initCell(_ adjective: String,
                  _ noun: String,
                  _ icon: String,
                  _ lr: Int, _ lg: Int, _ lb: Int,
                  _ dr: Int, _ dg: Int, _ db: Int) {
        tagLabel.text = adjective + " " + noun
        
        tagImageView.image = UIImage(named: icon)
        
        if #available(iOS 13, *) {
            if traitCollection.userInterfaceStyle == .light {
                bgView.backgroundColor = UIColor(red: CGFloat(lr) / 255.0, green: CGFloat(lg) / 255.0, blue: CGFloat(lb) / 255.0, alpha: 1.0)
            } else {
                bgView.backgroundColor = UIColor(red: CGFloat(dr) / 255.0, green: CGFloat(dg) / 255.0, blue: CGFloat(db) / 255.0, alpha: 1.0)
            }
        } else {
            bgView.backgroundColor = UIColor(red: CGFloat(lr) / 255.0, green: CGFloat(lg) / 255.0, blue: CGFloat(lb) / 255.0, alpha: 1.0)
        }
    }
}

// MARK: - extension

extension TagCVC {
    private func setUI() {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let width = windowScene?.windows.first?.frame.width ?? 0
        
        bgView.layer.cornerRadius = ((width - 48) / 327 * 48) / 2
        
        tagLabel.font = .textBold02
        tagLabel.textColor = .white
        
        selectedBgView.isHidden = true
        selectedBgView.backgroundColor = .black.withAlphaComponent(0.6)
        selectedBgView.layer.cornerRadius = ((width - 48) / 327 * 48) / 2
        
        checkImageView.image = UIImage(named: "icnTagCheck")
    }
    private func setLayout() {
        contentView.addSubviews([bgView, tagImageView, tagLabel, selectedBgView])
        
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        tagImageView.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview().inset(10)
            make.width.equalTo(tagImageView.snp.height)
        }
        
        tagLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        selectedBgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        selectedBgView.addSubview(checkImageView)
        
        checkImageView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(14)
            make.centerX.equalToSuperview()
            make.width.equalTo(checkImageView.snp.height)
        }
    }
}
