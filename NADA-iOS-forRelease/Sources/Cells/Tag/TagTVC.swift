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
        
        setUI()
        setLayout()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        selectedBgView.isHidden = false
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }
}

// MARK: - Initialize

extension TagTVC {
    func initCell(_ adjective: String,
                  noun: String,
                  _ icon: String,
                  _ lr: Int, _ lg: Int, _ lb: Int,
                  _ dr: Int, _ dg: Int, _ db: Int) {
        tagLabel.text = adjective + " " + noun
        
        tagImageView.image = UIImage(named: icon)
        
        if #available(iOS 13, *) {
            if traitCollection.userInterfaceStyle == .light {
                backgroundView?.backgroundColor = UIColor(red: CGFloat(lr) / 255.0, green: CGFloat(lg) / 255.0, blue: CGFloat(lb) / 255.0, alpha: 1.0)
            } else {
                backgroundView?.backgroundColor = UIColor(red: CGFloat(dr) / 255.0, green: CGFloat(dg) / 255.0, blue: CGFloat(db) / 255.0, alpha: 1.0)
            }
        } else {
            backgroundView?.backgroundColor = UIColor(red: CGFloat(lr) / 255.0, green: CGFloat(lg) / 255.0, blue: CGFloat(lb) / 255.0, alpha: 1.0)
        }
    }
}

// MARK: - extension

extension TagTVC {
    private func setUI() {
        bgView.layer.cornerRadius = bgView.frame.height / 2
        
        tagLabel.font = .textBold02
        tagLabel.textColor = .background
        
        selectedBgView.isHidden = true
        selectedBgView.backgroundColor = .black.withAlphaComponent(0.6)
        selectedBgView.layer.cornerRadius = bgView.frame.height / 2
        
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
            make.width.equalTo(checkImageView.snp.height)
        }
    }
}
