//
//  QRScanViewController.swift
//  NADA-iOS-forRelease
//
//  Created by Yi Joon Choi on 2021/11/26.
//

import UIKit
import AVFoundation

class QRScanViewController: UIViewController {

    // MARK: - Properties
    private let captureSession = AVCaptureSession()
    
    // 네비게이션 바
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "QR스캔"
        label.textColor = .white
        label.font = UIFont.title01
        return label
    }()
    
    private let dismissButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "iconQRClear"), for: .normal)
        button.addTarget(self, action: #selector(dismissQRScanViewController), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        basicSetting()
        setNotification()
    }
}

extension QRScanViewController {
    @objc func dismissQRScanViewController() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension QRScanViewController {
    
    private func basicSetting() {
        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            fatalError("No video device found")
        }
        do {
            let rectOfInterest = CGRect(x: 24, y: (UIScreen.main.bounds.height - 200) / 2, width: 327, height: 327)
            
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(input)
            
            let output = AVCaptureMetadataOutput()
            captureSession.addOutput(output)
            
            output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            
            let rectConverted = setVideoLayer(rectOfInterest: rectOfInterest)
            output.rectOfInterest = rectConverted
            
            setGuideLineView(rectOfInterest: rectOfInterest)
            captureSession.startRunning()
        } catch {
            print("QRScanViewController - AVCaptureDevice error")
        }
    }
    
    private func setVideoLayer(rectOfInterest: CGRect) -> CGRect {
        let videoLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoLayer.frame = view.layer.bounds
        videoLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        view.layer.addSublayer(videoLayer)
        
        return videoLayer.metadataOutputRectConverted(fromLayerRect: rectOfInterest)
    }
    
    private func setGuideLineView(rectOfInterest: CGRect) {
        let guideImage = UIImageView()
        guideImage.image = UIImage(named: "subtract")
        guideImage.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        view.addSubview(dismissButton)
        view.addSubview(guideImage)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 68),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24)
        ])
        
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dismissButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 68),
            dismissButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
        
        NSLayoutConstraint.activate([
            guideImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            guideImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            guideImage.widthAnchor.constraint(equalToConstant: 327),
            guideImage.heightAnchor.constraint(equalToConstant: 327)
        ])
    }
    
    private func setNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(captureSessionStartRunning), name: .dismissQRCodeCardResult, object: nil)
    }
    
    @objc
    private func captureSessionStartRunning() {
        captureSession.startRunning()
    }
}

extension QRScanViewController: AVCaptureMetadataOutputObjectsDelegate {

    func metadataOutput(_ captureOutput: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {

        if let metadataObject = metadataObjects.first {

            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject, let stringValue = readableObject.stringValue else {
                return
            }

            // ✅ qr코드가 가진 문자열이 URL 형태를 띈다면 출력.(아무런 qr코드나 찍는다고 출력시키면 안되니까 여기서 분기처리 가능. )
            if stringValue.hasPrefix("ThisIsTeamNADAQrCode") {
                self.captureSession.stopRunning()
                // TODO: 여기서 QR에 있는 ID값으로 명함검색 API통신
                cardDetailFetchWithAPI(cardID: stringValue.deletingPrefix("ThisIsTeamNADAQrCode"))
                
            } else {
                showToast(message: "유효하지 않은 QR입니다.", font: UIFont.button02, view: "QRScan")
            }
        }
    }
}

extension QRScanViewController {
    func cardDetailFetchWithAPI(cardID: String) {
        CardAPI.shared.cardDetailFetch(cardID: cardID) { response in
            switch response {
            case .success(let data):
                if let card = data as? CardClass {
                    if UserDefaults.standard.string(forKey: Const.UserDefaultsKey.userID) == card.card.author {
                        self.showToast(message: "자신의 명함은 추가할 수 없습니다.", font: UIFont.button02, view: "wrongCard")
                    } else {
                        let nextVC = CardResultBottomSheetViewController()
                            .setTitle(card.card.name)
                            .setHeight(574)
                        nextVC.cardDataModel = card.card
                        nextVC.modalPresentationStyle = .overFullScreen
                        nextVC.status = .addWithQR
                        self.present(nextVC, animated: false, completion: nil)
                    }
                }
            case .requestErr(let message):
                print("cardDetailFetchWithAPI - requestErr: \(message)")
            case .pathErr:
                print("cardDetailFetchWithAPI - pathErr")
            case .serverErr:
                print("cardDetailFetchWithAPI - serverErr")
            case .networkFail:
                print("cardDetailFetchWithAPI - networkFail")
            }
        }
    }
}
