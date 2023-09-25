//
//  TagTVC.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2023/09/25.
//

import UIKit

import SnapKit

class TagTVC: UITableViewCell {
    
    // MARK: - Components
    
    private let bgView = UIView()
    private let tagImageView = UIImageView()
    private let tagLabel = UILabel()
    private let selectedBgView = UIView()
    private let checkImageView = UIImageView()

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
// MARK: - extension

extension TagTVC {
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
            make.width.equalTo(checkImageView.snp.height)
        }
    }
}
