//
//  CardShareBottomSheetViewController.swift
//  NADA-iOS-forRelease
//
//  Created by Yi Joon Choi on 2021/12/21.
//

import UIKit
import Photos

import FirebaseDynamicLinks
import Lottie

class CardShareBottomSheetViewController: CommonBottomSheetViewController {

    // MARK: - Properties

    public var isShareable = false
    public var cardDataModel: Card?
    public var isActivate: Bool?

    private let cardBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .card
        view.layer.cornerRadius = 10.0
        
        return view
    }()
    
    private let nearByBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .card
        view.layer.cornerRadius = 10.0
        
        return view
    }()
    
    private let nadaLogoImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "nadaLogoTxt")
        
        return imageView
    }()
    
    private let nearByImage: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    private let nearByLabel: UILabel = {
        let label = UILabel()
        label.font = .button02
        
        return label
    }()
    
    lazy
    private var nearBySwitch: UISwitch = {
        let nearBySwitch = UISwitch()
        nearBySwitch.onTintColor = .mainColorNadaMain
        nearBySwitch.addTarget(self, action: #selector(touchSwitch), for: .valueChanged)
        
        return nearBySwitch
    }()
    
    private let qrImage: UIImageView = {
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: 189, height: 189)
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
    
    lazy
    private var copyButton: UIButton = {
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
    
    lazy
    private var saveAsImageButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "buttonShareImg"), for: .normal)
        button.addTarget(self, action: #selector(saveAsImage), for: .touchUpInside)
        
        return button
    }()
    
    lazy
    private var lottieImage: LottieAnimationView = {
        let view = LottieAnimationView(name: Const.Lottie.nearby)
        view.loopMode = .loop
        
        return view
    }()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - @Functions
    
    private func setupUI() {
        view.addSubviews([cardBackgroundView, nearByBackgroundView])
        
        idStackView.addArrangedSubview(idTitleLabel)
        idStackView.addArrangedSubview(idLabel)
        idStackView.addArrangedSubview(copyButton)
        
        cardBackgroundView.addSubviews([nadaLogoImage, qrImage, idStackView, saveAsImageButton])
        
        nearByBackgroundView.addSubviews([nearByImage, nearByLabel, nearBySwitch, lottieImage])
        
        idLabel.text = cardDataModel?.cardID ?? ""
        
        setCardActivationUI(with: isActivate ?? false)
        
        setupLayout()
        setQRImage()
    }
    
    private func setCardActivationUI(with isActivate: Bool) {
        nearByBackgroundView.backgroundColor = isActivate ? .mainColorNadaMain.withAlphaComponent(0.15) : .card
        
        nearByImage.image = isActivate ? UIImage(named: "icnNearbyOn") : UIImage(named: "icnNearbyOff")
        
        nearByLabel.text = isActivate ? "내 근처의 명함 ON" : "내 근처의 명함 OFF"
        nearByLabel.textColor = isActivate ? .mainColorNadaMain : .tertiary
        
        nearBySwitch.setOn(isActivate, animated: false)
        
        lottieImage.isHidden = isActivate ? false : true
        _ = isActivate ? lottieImage.play() : lottieImage.stop()
    }
    
    private func setupLayout() {
        cardBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cardBackgroundView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20.0),
            cardBackgroundView.leadingAnchor.constraint(equalTo: bottomSheetView.leadingAnchor, constant: 24.0),
            cardBackgroundView.trailingAnchor.constraint(equalTo: bottomSheetView.trailingAnchor, constant: -24.0),
            cardBackgroundView.heightAnchor.constraint(equalToConstant: 384.0)
        ])
        
        nadaLogoImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nadaLogoImage.topAnchor.constraint(equalTo: cardBackgroundView.topAnchor, constant: 18.0),
            nadaLogoImage.leadingAnchor.constraint(equalTo: cardBackgroundView.leadingAnchor, constant: 18.0),
            nadaLogoImage.widthAnchor.constraint(equalToConstant: 84.0),
            nadaLogoImage.heightAnchor.constraint(equalToConstant: 30.0)
        ])
        
        qrImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            qrImage.topAnchor.constraint(equalTo: cardBackgroundView.topAnchor, constant: 64.0),
            qrImage.centerXAnchor.constraint(equalTo: cardBackgroundView.centerXAnchor),
            qrImage.widthAnchor.constraint(equalToConstant: 189.0),
            qrImage.heightAnchor.constraint(equalToConstant: 189.0)
        ])
        
        idStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            idStackView.topAnchor.constraint(equalTo: qrImage.bottomAnchor, constant: 15.0),
            idStackView.centerXAnchor.constraint(equalTo: cardBackgroundView.centerXAnchor)
        ])
        
        saveAsImageButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            saveAsImageButton.topAnchor.constraint(equalTo: idStackView.bottomAnchor, constant: 20.0),
            saveAsImageButton.centerXAnchor.constraint(equalTo: cardBackgroundView.centerXAnchor)
        ])
        
        nearByBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nearByBackgroundView.topAnchor.constraint(equalTo: cardBackgroundView.bottomAnchor, constant: 12.0),
            nearByBackgroundView.leadingAnchor.constraint(equalTo: bottomSheetView.leadingAnchor, constant: 24.0),
            nearByBackgroundView.trailingAnchor.constraint(equalTo: bottomSheetView.trailingAnchor, constant: -24.0),
            nearByBackgroundView.heightAnchor.constraint(equalToConstant: 60.0)
        ])
        
        nearByImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nearByImage.centerYAnchor.constraint(equalTo: nearByBackgroundView.centerYAnchor),
            nearByImage.heightAnchor.constraint(equalToConstant: 54.0),
            nearByImage.widthAnchor.constraint(equalToConstant: 54.0)
        ])
        
        nearByLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nearByLabel.centerYAnchor.constraint(equalTo: nearByBackgroundView.centerYAnchor),
            nearByLabel.leadingAnchor.constraint(equalTo: nearByImage.trailingAnchor)
        ])
        
        nearBySwitch.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nearBySwitch.centerYAnchor.constraint(equalTo: nearByBackgroundView.centerYAnchor),
            nearBySwitch.trailingAnchor.constraint(equalTo: nearByBackgroundView.trailingAnchor, constant: -20.0),
            nearBySwitch.heightAnchor.constraint(equalToConstant: 31.0),
            nearBySwitch.widthAnchor.constraint(equalToConstant: 51.0)
        ])
        
        lottieImage.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            lottieImage.centerXAnchor.constraint(equalTo: nearByImage.centerXAnchor),
            lottieImage.centerYAnchor.constraint(equalTo: nearByImage.centerYAnchor)
        ])
    }
    
    private func setQRImage() {
        let frame = CGRect(origin: .zero, size: qrImage.frame.size)
        let qrcode = QRCodeView(frame: frame)
        generateDynamicLink(with: cardDataModel?.cardID ?? "") { dynamicLink in
            qrcode.generateCode(dynamicLink,
                                foregroundColor: .primary,
                                backgroundColor: .card)
            self.qrImage.addSubview(qrcode)
        }
    }
    
    private func generateDynamicLink(with cardID: String, completion: @escaping ((String) -> Void)) {
        guard let link = URL(string: Const.URL.opendDynamicLinkOnWebURL + "/?cardID=" + cardID),
              let bundleID = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String else { return }
        let domainURLPrefix = Const.URL.dynamicLinkURLPrefix
        let appStoreID = "1600711887"
        
        let linkBuilder = DynamicLinkComponents(link: link, domainURIPrefix: domainURLPrefix)
        
        linkBuilder?.iOSParameters = DynamicLinkIOSParameters(bundleID: bundleID)
        linkBuilder?.iOSParameters?.appStoreID = appStoreID
        linkBuilder?.navigationInfoParameters = DynamicLinkNavigationInfoParameters()
        linkBuilder?.navigationInfoParameters?.isForcedRedirectEnabled = true
        
        var dynamicLink: String = ""
        
        linkBuilder?.options = DynamicLinkComponentsOptions()
        linkBuilder?.options?.pathLength = .short
        
        linkBuilder?.shorten { url, warnings, error in
            if let url {
                dynamicLink = "\(url)"
            }
            
            completion(dynamicLink)
        }
    }
    
    private func setImageWriteToSavedPhotosAlbum() {
        let frontCardImage = setFrontCardImage()
        let backCardImage = setBackCardImage()
        
        switch PHPhotoLibrary.authorizationStatus() {
        case .authorized:
            UIImageWriteToSavedPhotosAlbum(frontCardImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
            UIImageWriteToSavedPhotosAlbum(backCardImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        case .denied:
            makeOKCancelAlert(title: "갤러리 권한이 허용되어 있지 않아요.",
                              message: "명함 이미지 저장을 위해 갤러리 권한이 필요합니다. 앱 설정으로 이동해 허용해 주세요.",
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
    
    // FIXME: - 명함 저장시에도 테두리 둥글게 가능한가 찾기
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
    
    @objc
    private func copyId() {
        UIPasteboard.general.string = cardDataModel?.cardID ?? ""
        showToast(message: "명함 아이디가 복사되었습니다.", font: UIFont.button02, view: "copyID")
    }
    
    @objc
    private func saveAsImage() {
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
    
    @objc func touchSwitch(_ sender: UISwitch) {
        setCardActivationUI(with: sender.isOn)
    }
}
