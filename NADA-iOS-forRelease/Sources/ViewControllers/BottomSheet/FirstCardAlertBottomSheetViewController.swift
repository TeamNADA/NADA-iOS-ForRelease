//
//  FirstCardAlertBottomSheetViewController.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2021/12/22.
//

import UIKit

class FirstCardAlertBottomSheetViewController: CommonBottomSheetViewController {

    // MARK: - Properties

    private let cardImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "imgFirstcard")
        
       return imageView
    }()
    
    private let bgView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.backgroundColor = .textBox
        
        return view
    }()
    
    private let firstHandIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "firsthandIcon")
        
        return imageView
    }()
    
    private let secondHandIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "secondhandIcon")
        
        return imageView
    }()

    private let firstSubtitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 2
        let attributedString = NSMutableAttributedString(string: "명함을 좌우로 스와이프하여\n 앞/뒷면을 확인할 수 있어요.")
        attributedString.addAttributes([.foregroundColor: UIColor.primary, .font: UIFont.textRegular03], range: NSRange(location: 0, length: 3))
        attributedString.addAttributes([.foregroundColor: UIColor.mainColorNadaMain, .font: UIFont.textBold01], range: NSRange(location: 4, length: 8))
        attributedString.addAttributes([.foregroundColor: UIColor.primary, .font: UIFont.textRegular03], range: NSRange(location: 14, length: 16))
        label.attributedText = attributedString
    
        return label
    }()
    
    private let secondSubtitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 2
        let attributedString = NSMutableAttributedString(string: "우측 상단의 공유 버튼을 통해\n 친구에게 공유해 보세요.")
        attributedString.addAttributes([.foregroundColor: UIColor.mainColorNadaMain, .font: UIFont.textBold01], range: NSRange(location: 0, length: 12))
        attributedString.addAttributes([.foregroundColor: UIColor.primary, .font: UIFont.textRegular03], range: NSRange(location: 13, length: 17))
        label.attributedText = attributedString
        
        return label
    }()

    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - Methods
    
    // UI 세팅 작업
    private func setupUI() {
        titleLabel.numberOfLines = 2
        
        view.addSubview(cardImageView)
        view.addSubview(bgView)
        bgView.addSubview(firstHandIcon)
        bgView.addSubview(secondHandIcon)
        bgView.addSubview(firstSubtitleLabel)
        bgView.addSubview(secondSubtitleLabel)
        
        setupLayout()
    }
    
    // 레이아웃 세팅
    private func setupLayout() {
        cardImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cardImageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            cardImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 70),
            cardImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -70)
        ])
        
        bgView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bgView.topAnchor.constraint(equalTo: cardImageView.bottomAnchor, constant: 16),
            bgView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            bgView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            bgView.heightAnchor.constraint(equalToConstant: 194)
            
        ])
        
        firstHandIcon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            firstHandIcon.topAnchor.constraint(equalTo: bgView.topAnchor, constant: 16),
            firstHandIcon.centerXAnchor.constraint(equalTo: bgView.centerXAnchor)
        ])
        
        secondHandIcon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            secondHandIcon.topAnchor.constraint(equalTo: firstSubtitleLabel.bottomAnchor, constant: 16),
            secondHandIcon.centerXAnchor.constraint(equalTo: bgView.centerXAnchor)
        ])
        
        firstSubtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            firstSubtitleLabel.topAnchor.constraint(equalTo: firstHandIcon.bottomAnchor, constant: 2),
            firstSubtitleLabel.centerXAnchor.constraint(equalTo: bgView.centerXAnchor)
        ])
        
        secondSubtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            secondSubtitleLabel.topAnchor.constraint(equalTo: secondHandIcon.bottomAnchor, constant: 2),
            secondSubtitleLabel.centerXAnchor.constraint(equalTo: bgView.centerXAnchor)
        ])
    }
}
