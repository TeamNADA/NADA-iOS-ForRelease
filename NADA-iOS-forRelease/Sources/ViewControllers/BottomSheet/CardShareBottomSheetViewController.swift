//
//  CardShareBottomSheetViewController.swift
//  NADA-iOS-forRelease
//
//  Created by Yi Joon Choi on 2021/12/21.
//

import UIKit
import Photos

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
    // UI μΈν μμ
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
    
    // λ μ΄μμ μΈν
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
        qrImage.addSubview(qrcode)
    }
    
    private func setImageWriteToSavedPhotosAlbum() {
        let frontCardImage = setFrontCardImage()
        let backCardImage = setBackCardImage()
        
        switch PHPhotoLibrary.authorizationStatus() {
        case .authorized:
            UIImageWriteToSavedPhotosAlbum(frontCardImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
            UIImageWriteToSavedPhotosAlbum(backCardImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        case .denied:
            makeOKCancelAlert(title: "κ°€λ¬λ¦¬ κΆνμ΄ νμ©λμ΄ μμ§ μμμ.",
                        message: "λͺν¨ μ΄λ―Έμ§ μ μ₯μ μν΄ κ°€λ¬λ¦¬ κΆνμ΄ νμν©λλ€. μ± μ€μ μΌλ‘ μ΄λν΄ νμ©ν΄ μ£ΌμΈμ.",
                        okAction: { _ in UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)},
                        cancelAction: nil,
                        completion: nil)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({state in
                if state == .authorized {
                    UIImageWriteToSavedPhotosAlbum(frontCardImage, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
                    UIImageWriteToSavedPhotosAlbum(backCardImage, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
                } else {
                    DispatchQueue.main.async {
                        self.hideBottomSheetAndGoBack()
                    }
                }
            })
        default:
            break
        }
        
    }
    
    // FIXME: - λͺν¨ μ μ₯μμλ νλλ¦¬ λ₯κΈκ² κ°λ₯νκ° μ°ΎκΈ°
    private func setFrontCardImage() -> UIImage {
        guard let frontCard = FrontCardCell.nib().instantiate(withOwner: self, options: nil).first as? FrontCardCell else { return UIImage() }
        
        frontCard.frame = CGRect(x: 0, y: 0, width: 327, height: 540)
        guard let cardDataModel = cardDataModel else { return UIImage() }
        frontCard.initCellFromServer(cardData: cardDataModel, isShareable: isShareable)
        
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
        backCard.initCellFromServer(cardData: cardDataModel, isShareable: isShareable)

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
        showToast(message: "λͺν¨ μμ΄λκ° λ³΅μ¬λμμ΅λλ€.", font: UIFont.button02, view: "copyID")
    }
    
    @objc func saveAsImage() {
        setImageWriteToSavedPhotosAlbum()
    }

    @objc
    private func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeMutableRawPointer) {
        if let error = error {
            print(error.localizedDescription)
        } else {
            showToast(message: "κ°€λ¬λ¦¬μ μ μ₯λμμ΅λλ€.", font: UIFont.button02, view: "saveImage")
        }
    }
}
