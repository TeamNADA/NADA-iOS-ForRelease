//
//  OnboardingCollectionViewCell.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2021/12/05.
//

import UIKit

import Lottie

class OnboardingCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var presentToLoginViewController: (() -> Void)?
    private let onboardingFirstLottieView = LottieAnimationView(name: Const.Lottie.onboarding01)
    private let onboardingSecondLottieView = LottieAnimationView(name: Const.Lottie.onboarding02)

    // MARK: - @IBOutlet Properties
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var startButton: UIButton!
    
    // MARK: - View Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()

        setUI()
        setLayout()
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
    private func setLayout() {
        self.contentView.addSubviews([onboardingFirstLottieView, onboardingSecondLottieView])
        
        onboardingFirstLottieView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            onboardingFirstLottieView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 56),
            onboardingFirstLottieView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 64),
            onboardingFirstLottieView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -63),
            onboardingFirstLottieView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -134)
        ])
        
        onboardingSecondLottieView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            onboardingSecondLottieView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 20),
            onboardingSecondLottieView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 10),
            onboardingSecondLottieView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor, constant: -10),
            onboardingSecondLottieView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -117)
        ])
    }
}

// MARK: - Initialize Methods

extension OnboardingCollectionViewCell {
    func initCell(image: String, index: Int) {
        if let image = UIImage(named: image) {
            imageView.image = image
        }
        
        if index == 0 {
            onboardingFirstLottieView.isHidden = false
            onboardingSecondLottieView.isHidden = true
            startButton.isHidden = true
        } else if index == 1 {
            onboardingFirstLottieView.isHidden = true
            onboardingSecondLottieView.isHidden = false
            startButton.isHidden = true
        } else if index == 4 {
            onboardingFirstLottieView.isHidden = true
            onboardingSecondLottieView.isHidden = true
            startButton.isHidden = false
        } else {
            onboardingFirstLottieView.isHidden = true
            onboardingSecondLottieView.isHidden = true
            startButton.isHidden = true
        }
    }
}
