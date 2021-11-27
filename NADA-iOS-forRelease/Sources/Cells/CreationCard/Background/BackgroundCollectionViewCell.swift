//
//  CardBackgroundSettingCell.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2021/09/26.
//

import UIKit

class BackgroundCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    private let bgViewCornerRadius: CGFloat = 30
    private let imageviewCornerRadius: CGFloat = 28
    
    // MARK: - @IBOutlet Properties
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - View Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUI()
    }
}

// MARK: - Extensions

extension BackgroundCollectionViewCell {
    private func setUI() {
        bgView.backgroundColor = .tertiary
        bgView.isHidden = true
        bgView.layer.cornerRadius = bgView.frame.height / 2
        bgView.layer.cornerRadius = bgViewCornerRadius
        imageView.layer.cornerRadius = imageviewCornerRadius
    }
    func initCell(image: String) {
        if let image = UIImage(named: image) {
            imageView.image = image
        }
    }
    override var isSelected: Bool {
        didSet {
            if isSelected {
                bgView.isHidden = false
            } else {
                bgView.isHidden = true
            }
        }
    }
    static func nib() -> UINib {
        return UINib(nibName: Const.Xib.backgroundCollectionViewCell, bundle: nil)
    }
}
