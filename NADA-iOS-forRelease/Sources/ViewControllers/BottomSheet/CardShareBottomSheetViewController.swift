//
//  CardShareBottomSheetViewController.swift
//  NADA-iOS-forRelease
//
//  Created by Yi Joon Choi on 2021/12/21.
//

import UIKit

class CardShareBottomSheetViewController: CommonBottomSheetViewController {

    // MARK: - Properties
    private let qrImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "qrCodeImg21")
        
        return imageView
    }()
    
    private let idTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "ID"
        label.textColor = .secondary
        label.font = .title01
        
        return label
    }()
    
    private let idLabel: UILabel = {
        let label = UILabel()
        label.text = "1D856A"
        label.textColor = .secondary
        label.font = .textRegular01
        
        return label
    }()
    
    private let copyButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "iconCopy"), for: .normal)
        button.addTarget(self, action: #selector(copyId), for: .touchUpInside)
        
        return button
    }()
    
    private let idStackView: UIStackView = {
        let stackView = UIStackView()
//        [self.idTitle]
        stackView.axis = .horizontal
        return stackView
    }()
    
    private let saveAsImageButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "buttonShareImg"), for: .normal)
        button.addTarget(self, action: #selector(saveAsImage), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - @Functions
    // UI 세팅 작업
    private func setupUI() {
        view.addSubview(qrImage)
        view.addSubview(idStackView)
        view.addSubview(saveAsImageButton)
        setupLayout()
    }
    
    // 레이아웃 세팅
    private func setupLayout() {
        qrImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            qrImage.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            qrImage.centerXAnchor.constraint(equalTo: bottomSheetView.centerXAnchor),
            qrImage.widthAnchor.constraint(equalToConstant: 160),
            qrImage.heightAnchor.constraint(equalToConstant: 160)
        ])
        
        idStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            idStackView.topAnchor.constraint(equalTo: qrImage.bottomAnchor, constant: 9),
            idStackView.centerXAnchor.constraint(equalTo: bottomSheetView.centerXAnchor)
        ])
        
        saveAsImageButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            saveAsImageButton.topAnchor.constraint(equalTo: idStackView.bottomAnchor, constant: 32),
            saveAsImageButton.centerXAnchor.constraint(equalTo: bottomSheetView.centerXAnchor),
            saveAsImageButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 107)
        ])
    }
    
    @objc func copyId() {
        print("next bottomsheet")
    }
    
    @objc func saveAsImage() {
        print("next bottomsheet")
    }

}
