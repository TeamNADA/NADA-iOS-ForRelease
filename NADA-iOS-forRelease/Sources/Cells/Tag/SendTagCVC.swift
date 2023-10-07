//
//  SendTagCVC.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2023/10/05.
//

import UIKit

import SnapKit

class SendTagCVC: UICollectionViewCell {
    
    // MARK: - Components
    
    private let bgView = UIView()
    private let checkImageView = UIImageView()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setUI()
        setLayout()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setLayout()
    }
    
    override var isSelected: Bool {
        didSet {
            checkImageView.isHidden = !isSelected
        }
    }
}

// MARK: - Extension

extension SendTagCVC {
    private func setUI() {
        checkImageView.image = UIImage(named: "icnOptionCheck")
        bgView.layer.cornerRadius = 16
        checkImageView.isHidden = true
    }
    private func setLayout() {
        contentView.addSubviews([bgView, checkImageView])
        
        bgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        checkImageView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
}

// MARK: - Initialize

extension SendTagCVC {
    public func initCell(_ lr: Int, _ lg: Int, _ lb: Int,
                         _ dr: Int, _ dg: Int, _ db: Int) {
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
