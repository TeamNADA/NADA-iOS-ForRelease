//
//  CardShareBottomSheetViewController.swift
//  NADA-iOS-forRelease
//
//  Created by Yi Joon Choi on 2021/12/21.
//

import UIKit

class CardShareBottomSheetViewController: CommonBottomSheetViewController {

    // MARK: - Properties

    var isShareable = false
    var cardDataModel: Card?

    private let qrImage: UIImageView = {
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: 160, height: 160)
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
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fill
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
        idStackView.addArrangedSubview(idTitleLabel)
        idStackView.addArrangedSubview(idLabel)
        idStackView.addArrangedSubview(copyButton)
        
        view.addSubview(qrImage)
        view.addSubview(idStackView)
        view.addSubview(saveAsImageButton)
        
        idLabel.text = cardDataModel?.cardID ?? ""
        
        setupLayout()
        setQRImage()
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
    
    private func setQRImage() {
        let frame = CGRect(origin: .zero, size: qrImage.frame.size)
        print("TeamNADA\(cardDataModel?.cardID ?? "")")
        let qrcode = QRCodeView(frame: frame)
        qrcode.generateCode("ThisIsTeamNADAQrCode\(cardDataModel?.cardID ?? "")",
                            foregroundColor: .primary,
                            backgroundColor: .background)
//        qrcode.generateCode("ThisIsTeamNADAQrCodeCardE",
//                            foregroundColor: .primary,
//                            backgroundColor: .background)
        qrImage.addSubview(qrcode)
    }
    
    private func setImageWriteToSavedPhotosAlbum() {
        let frontCardImage = setFrontCardImage()
        let backCardImage = setBackCardImage()
        
        UIImageWriteToSavedPhotosAlbum(frontCardImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        UIImageWriteToSavedPhotosAlbum(backCardImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    // FIXME: - 명함 저장시에도 테두리 둥글게 가능한가 찾기
    private func setFrontCardImage() -> UIImage {
        guard let frontCard = FrontCardCell.nib().instantiate(withOwner: self, options: nil).first as? FrontCardCell else { return UIImage() }
        
        frontCard.frame = CGRect(x: 0, y: 0, width: 327, height: 540)
        guard let cardDataModel = cardDataModel else { return UIImage() }
        frontCard.initCell(UIImage(named: cardDataModel.background),
                           cardDataModel.title,
                           cardDataModel.cardDescription ?? "",
                           cardDataModel.name,
                           cardDataModel.birthDate,
                           cardDataModel.mbti,
                           cardDataModel.instagram ?? "",
                           cardDataModel.link ?? "",
                           isShareable: isShareable)
        
        let frontCardView = UIView(frame: CGRect(x: 0, y: 0, width: 327, height: 540))
        frontCardView.addSubview(frontCard)
        
        let renderer = UIGraphicsImageRenderer(size: frontCardView.bounds.size)
        let frontImage = renderer.image { _ in
            frontCardView.drawHierarchy(in: frontCardView.bounds, afterScreenUpdates: true)
        }
        
        return frontImage
    }
    private func setBackCardImage() -> UIImage {
        guard let backCard = BackCardCell.nib().instantiate(withOwner: self, options: nil).first as? BackCardCell else { return UIImage() }
        backCard.frame = CGRect(x: 0, y: 0, width: 327, height: 540)
        guard let cardDataModel = cardDataModel else { return UIImage() }
        backCard.initCell(UIImage(named: cardDataModel.background),
                          cardDataModel.isMincho,
                          cardDataModel.isSoju,
                          cardDataModel.isBoomuk,
                          cardDataModel.isSauced,
                          cardDataModel.oneTmi ?? "",
                          cardDataModel.twoTmi ?? "",
                          cardDataModel.threeTmi ?? "",
                          isShareable: isShareable)

        let backCardView = UIView(frame: CGRect(x: 0, y: 0, width: 327, height: 540))
        backCardView.addSubview(backCard)
        
        let renderer = UIGraphicsImageRenderer(size: backCardView.bounds.size)
        let backImage = renderer.image { _ in
            backCardView.drawHierarchy(in: backCardView.bounds, afterScreenUpdates: true)
        }
        
        return backImage
    }
    
    // MARK: - @objc Methods
    
    @objc func copyId() {
        UIPasteboard.general.string = cardDataModel?.cardID ?? ""
        showToast(message: "명함 아이디가 복사되었습니다.", font: UIFont.button02, view: "copyID")
    }
    
    @objc func saveAsImage() {
        setImageWriteToSavedPhotosAlbum()
    }

    @objc
    private func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeMutableRawPointer) {
        if let error = error {
            print(error.localizedDescription)
        } else {
            showToast(message: "갤러리에 저장되었습니다.", font: UIFont.button02, view: "saveImage")
        }
    }
}
