//
//  CardShareBottomSheetViewController.swift
//  NADA-iOS-forRelease
//
//  Created by Yi Joon Choi on 2021/12/21.
//

import CoreLocation
import UIKit
import Photos

import FirebaseDynamicLinks
import Lottie

class CardShareBottomSheetViewController: CommonBottomSheetViewController {

    // MARK: - Properties

    public var isShareable = false
    public var cardDataModel: Card?
    public var isActivate: Bool?
    private weak var timer: Timer?
    private var seconds = 0
    private var savedTime = "10:00"
    private var timesLeft = 600
    private var appDidEnterBackgroundDate: Date?
    var locationManager = CLLocationManager()
    
    private var latitude: CLLocationDegrees = 0
    private var longitude: CLLocationDegrees = 0

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
    
    private let nearByTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .button02
        label.textColor = .mainColorNadaMain
        label.sizeToFit()
        
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
        setLocationManager()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setNotification()
        nearByUUIDFetchWithAPI(cardUUID: cardDataModel?.cardUUID ?? "")
    }
    
    // MARK: - @Functions
    
    private func setupUI() {
        view.addSubviews([cardBackgroundView, nearByBackgroundView])
        
        idStackView.addArrangedSubview(idTitleLabel)
        idStackView.addArrangedSubview(idLabel)
        idStackView.addArrangedSubview(copyButton)
        
        cardBackgroundView.addSubviews([nadaLogoImage, qrImage, idStackView, saveAsImageButton])
        
        nearByBackgroundView.addSubviews([nearByImage, nearByLabel, nearByTimeLabel, nearBySwitch, lottieImage])
        
        idLabel.text = cardDataModel?.cardUUID ?? ""
        
        setCardActivationUI(with: isActivate ?? false, secondsLeft: 0)
        
        setupLayout()
        setQRImage()
    }
    
    private func setCardActivationUIWithAPI(with isActivate: Bool) {
        nearByBackgroundView.backgroundColor = isActivate ? .mainColorNadaMain.withAlphaComponent(0.15) : .card
        
        nearByImage.image = isActivate ? UIImage(named: "icnNearbyOn") : UIImage(named: "icnNearbyOff")
        
        nearByLabel.text = isActivate ? "내 근처의 명함 ON" : "내 근처의 명함 OFF"
        nearByLabel.textColor = isActivate ? .mainColorNadaMain : .tertiary
        nearByTimeLabel.isHidden = !isActivate
        
        nearBySwitch.setOn(isActivate, animated: false)
        
        lottieImage.isHidden = isActivate ? false : true
        _ = isActivate ? lottieImage.play() : lottieImage.stop()
        
        // TODO: 여기서 스위치 키면 위치정보 받아오기, 끄면 위치 정보 노출하지 않기
        locationManager.startUpdatingLocation()
        latitude = locationManager.location?.coordinate.latitude ?? 0
        longitude = locationManager.location?.coordinate.longitude ?? 0
        
        if isActivate {
            //TODO: 여기서 활성화된 명함 정보/위치정보 API로 쏴주기
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(processTimer), userInfo: nil, repeats: true)
            
            print("✅✅ activated")
            print("✅ latitude: ", latitude)
            print("✅ longitude: ", longitude)
            postNearByCardWithAPI(nearByRequest: NearByRequest(cardUUID: cardDataModel?.cardUUID ?? "", isActive: true, latitude: latitude, longitude: longitude))
            
        } else {
            // TODO: 여기서 비활성화된 명함 정보/위치정보 API로 쏴주기
            timer?.invalidate()
            seconds = 0
            timesLeft = 600
            nearByTimeLabel.text = "10:00"
            print("✅✅✅ deactivated")
            print("✅ latitude: ", latitude)
            print("✅ longitude: ", longitude)
            postNearByCardWithAPI(nearByRequest: NearByRequest(cardUUID: cardDataModel?.cardUUID ?? "", isActive: false, latitude: latitude, longitude: longitude))
        }
    }
    
    private func setCardActivationUI(with isActivate: Bool, secondsLeft: Int) {
        nearByBackgroundView.backgroundColor = isActivate ? .mainColorNadaMain.withAlphaComponent(0.15) : .card
        
        nearByImage.image = isActivate ? UIImage(named: "icnNearbyOn") : UIImage(named: "icnNearbyOff")
        
        nearByLabel.text = isActivate ? "내 근처의 명함 ON" : "내 근처의 명함 OFF"
        nearByLabel.textColor = isActivate ? .mainColorNadaMain : .tertiary
        nearByTimeLabel.isHidden = !isActivate
        
        nearBySwitch.setOn(isActivate, animated: false)
        
        lottieImage.isHidden = isActivate ? false : true
        _ = isActivate ? lottieImage.play() : lottieImage.stop()
        
        if isActivate {
            //TODO: 여기서 활성화된 명함 정보/위치정보 API로 쏴주기
            if secondsLeft < 0 {
                postNearByCardWithAPI(nearByRequest: NearByRequest(cardUUID: cardDataModel?.cardUUID ?? "", isActive: false, latitude: latitude, longitude: longitude))
            }
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(processTimer), userInfo: nil, repeats: true)
            
            print("✅ activated")
            print("✅ latitude: ", latitude)
            print("✅ longitude: ", longitude)
        } else {
            // TODO: 여기서 비활성화된 명함 정보/위치정보 API로 쏴주기
            timer?.invalidate()
            seconds = 0
            timesLeft = 600
            nearByTimeLabel.text = "10:00"
            print("✅✅ deactivated")
        }
    }
    
    func setNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground(_:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterForeground(_:)), name: UIApplication.willEnterForegroundNotification, object: nil)
    }

    @objc func applicationDidEnterBackground(_ notification: NotificationCenter) {
        appDidEnterBackgroundDate = Date()
        savedTime = nearByTimeLabel.text ?? "00:00"
    }

    @objc func applicationWillEnterForeground(_ notification: NotificationCenter) {
        guard let previousDate = appDidEnterBackgroundDate else { return }
        let calendar = Calendar.current
        let difference = calendar.dateComponents([.second], from: previousDate, to: Date())
        let seconds = difference.second!

        if seconds >= 600 {
            postNearByCardWithAPI(nearByRequest: NearByRequest(cardUUID: cardDataModel?.cardUUID ?? "", isActive: false, latitude: latitude, longitude: longitude))
        } else {
            DispatchQueue.main.async {
                self.nearByTimeLabel.text = calculateMinuteTime(sec: calculateMinuteTimeToInt(time: self.savedTime) - seconds)
            }
        }
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
        
        nearByTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nearByTimeLabel.centerYAnchor.constraint(equalTo: nearByBackgroundView.centerYAnchor),
            nearByTimeLabel.trailingAnchor.constraint(equalTo: nearBySwitch.leadingAnchor, constant: -5.0)
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
        generateDynamicLink(with: cardDataModel?.cardUUID ?? "") { dynamicLink in
            qrcode.generateCode(dynamicLink,
                                foregroundColor: .primary,
                                backgroundColor: .card)
            self.qrImage.addSubview(qrcode)
        }
    }
    
    private func generateDynamicLink(with cardID: String, completion: @escaping ((String) -> Void)) {
        guard let link = URL(string: Const.URL.opendDynamicLinkOnWebURL + "/?cardUUID=" + cardID),
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
        backCard.initCell(cardDataModel.cardImage, cardDataModel.cardTastes, cardDataModel.tmi)

        let backCardView = UIView(frame: CGRect(x: 0, y: 0, width: 327, height: 540))
        backCardView.addSubview(backCard)
        
        let renderer = UIGraphicsImageRenderer(size: backCardView.bounds.size)
        let backImage = renderer.image { _ in
            backCardView.drawHierarchy(in: backCardView.bounds, afterScreenUpdates: true)
        }
        
        return backImage
    }
    
    private func setLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            print("location on")
            locationManager.startUpdatingLocation()
            print(locationManager.location?.coordinate)
        } else {
            print("location off")
        }
    }
    
    // MARK: - @objc Methods
    
    @objc
    private func copyId() {
        UIPasteboard.general.string = cardDataModel?.cardUUID ?? ""
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
        setCardActivationUIWithAPI(with: sender.isOn)
    }
    
    @objc
    func processTimer() {
        if timesLeft > 0 {
            seconds += 1
            timesLeft -= 1
            nearByTimeLabel.text = calculateMinuteTime(sec: timesLeft)
        } else {
            setCardActivationUIWithAPI(with: false)
        }
    }
}

extension CardShareBottomSheetViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("✅ 위도: ", location.coordinate.latitude)
            print("✅ 경도: ", location.coordinate.longitude)
            
            latitude = location.coordinate.latitude
            longitude = location.coordinate.longitude
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

// MARK: - Network

extension CardShareBottomSheetViewController {
    func postNearByCardWithAPI(nearByRequest: NearByRequest) {
        NearbyAPI.shared.postNearByCard(nearByRequest: nearByRequest) { response in
            switch response {
            case .success:
                print("postNearByCardWithAPI - success")
            case .requestErr(let message):
                print("postNearByCardWithAPI - requestErr: \(message)")
            case .pathErr:
                print("postNearByCardWithAPI - pathErr")
            case .serverErr:
                print("postNearByCardWithAPI - serverErr")
            case .networkFail:
                print("postNearByCardWithAPI - networkFail")
            }
        }
    }
    
    func nearByUUIDFetchWithAPI(cardUUID: String) {
        NearbyAPI.shared.nearByUUIDFetch(cardUUID: cardUUID) { response in
            switch response {
            case .success(let data):
                if let nearByUUIDResponse = data as? NearByUUIDResponse {
                    print("✅✅✅")
                    let interval = Date() - (nearByUUIDResponse.activeTime?.toDate() ?? Date())
                    self.timesLeft = 600 - (interval.second ?? 0) ?? 600
                    print("✅ now: ", Date())
                    print("✅ activated Time: ", nearByUUIDResponse.activeTime?.toDate())
                    print("✅ timesleft: ", self.timesLeft)
                    self.nearByTimeLabel.text = ""
                    self.setCardActivationUI(with: nearByUUIDResponse.isActive, secondsLeft: self.timesLeft ?? 0)
                }
                print("nearByUUIDFetchWithAPI - success")
            case .requestErr(let message):
                print("nearByUUIDFetchWithAPI - requestErr: \(message)")
            case .pathErr:
                print("nearByUUIDFetchWithAPI - pathErr")
            case .serverErr:
                print("nearByUUIDFetchWithAPI - serverErr")
            case .networkFail:
                print("nearByUUIDFetchWithAPI - networkFail")
            }
        }
    }
}
