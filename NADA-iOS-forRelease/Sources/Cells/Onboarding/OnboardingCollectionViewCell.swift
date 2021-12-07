//
//  OnboardingCollectionViewCell.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2021/12/05.
//

import UIKit

class OnboardingCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var presentToLoginViewController: (() -> Void)?

    // MARK: - @IBOutlet Properties
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var startButton: UIButton!
    
    // MARK: - View Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()

        setUI()
    }
    
    static func nib() -> UINib {
        return UINib(nibName: Const.Xib.onboardingCollectionViewCell, bundle: nil)
    }
    
    // MARK: - @IBAction Properties
    
    @IBAction func touchStartButton(_ sender: Any) {
        presentToLoginViewController?()
    }
}

// MARK: - Methods

extension OnboardingCollectionViewCell {
    private func setUI() {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 10
        
        contentView.layer.cornerRadius = 20
        contentView.layer.masksToBounds = false
        
        imageView.contentMode = .scaleAspectFill
    }
    func initCell(image: String, isLast: Bool) {
        if let image = UIImage(named: image) {
            imageView.image = image
        }
        startButton.isHidden = !isLast
    }
}
