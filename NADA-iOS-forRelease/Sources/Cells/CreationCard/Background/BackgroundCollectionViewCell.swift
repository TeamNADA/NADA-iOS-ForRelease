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
    @IBOutlet weak var opacityView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var addPhotoImageView: UIImageView!
    
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
        bgView.layer.cornerRadius = bgViewCornerRadius
        
        opacityView.layer.cornerRadius = imageviewCornerRadius
        imageView.layer.cornerRadius = imageviewCornerRadius
    }
    func initCell(image: UIImage, isFirst: Bool) {
        imageView.image = image
        addPhotoImageView.isHidden = isFirst == true ? false : true
        opacityView.isHidden = isFirst == true ? false : true
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
