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
}
