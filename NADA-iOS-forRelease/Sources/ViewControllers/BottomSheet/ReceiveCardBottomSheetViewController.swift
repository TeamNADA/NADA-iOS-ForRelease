//
//  ReceiveCardBottomSheetViewController.swift
//  NADA-iOS-forRelease
//
//  Created by Yi Joon Choi on 2023/04/11.
//

import Photos
import UIKit

import RxSwift
import RxRelay
import RxCocoa
import RxGesture
import SnapKit
import Then

class ReceiveCardBottomSheetViewController: CommonBottomSheetViewController {

    // MARK: - Properties
    
    private var moduleFactory = ModuleFactory.shared
    private let disposeBag = DisposeBag()
    
    // MARK: - UI Components
    
    private let byIdButton = UIButton().then {
        $0.backgroundColor = .button
        $0.setTitleColor(UIColor.tertiary, for: .normal)
        $0.setTitle("ID로 받기", for: .normal)
        $0.titleLabel?.font = .button01
        $0.layer.cornerRadius = 15
    }
    
    private let byQRButton = UIButton().then {
        $0.backgroundColor = .button
        $0.setTitleColor(UIColor.tertiary, for: .normal)
        $0.setTitle("QR로 받기", for: .normal)
        $0.titleLabel?.font = .button01
        $0.layer.cornerRadius = 15
    }
    
    private var stackview = UIStackView().then {
        $0.spacing = 12
        $0.distribution = .fillEqually
        $0.axis = .vertical
    }
    
    // MARK: - View Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        bindActions()
    }
    
}

extension ReceiveCardBottomSheetViewController {
    
    // MARK: - UI & Layout
    
    private func setLayout() {
        view.addSubview(stackview)
        stackview.addArrangedSubviews([byIdButton, byQRButton])
        stackview.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
            make.leading.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().offset(-54)
        }
    }
    
    // MARK: - Methods
    
    private func bindActions() {
        byIdButton.rx.tap
            .withUnretained(self)
            .subscribe { owner, _ in
                owner.makeVibrate(degree: .medium)
                let nextVC = AddWithIdBottomSheetViewController()
                self.hideBottomSheetAndPresent(nextBottomSheet: nextVC, title: "ID로 명함 추가", height: 184)
            }.disposed(by: self.disposeBag)
        
        byQRButton.rx.tap
            .withUnretained(self)
            .subscribe { owner, _ in
                owner.makeVibrate(degree: .medium)
                switch AVCaptureDevice.authorizationStatus(for: .video) {
                case .denied:
                    owner.makeOKCancelAlert(title: "카메라 권한이 허용되어 있지 않아요.",
                                message: "QR코드 인식을 위해 카메라 권한이 필요합니다. 앱 설정으로 이동해 허용해 주세요.",
                                okAction: { _ in UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)},
                                cancelAction: nil,
                                completion: nil)
                case .authorized:
                    if self.presentingViewController != nil {
                        guard let presentingVC = self.presentingViewController else { return }
                        self.dismiss(animated: false) {
                            guard let nextVC = UIStoryboard.init(name: Const.Storyboard.Name.qrScan, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.qrScanViewController) as? QRScanViewController else { return }
                            nextVC.modalPresentationStyle = .overFullScreen
                            presentingVC.present(nextVC, animated: false, completion: nil)
                        }
                    }
                case .notDetermined:
                    AVCaptureDevice.requestAccess(for: .video) { granted in
                        if granted {
                            DispatchQueue.main.async {
                                guard let nextVC = UIStoryboard.init(name: Const.Storyboard.Name.qrScan, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.qrScanViewController) as? QRScanViewController else { return }
                                nextVC.modalPresentationStyle = .overFullScreen
                                self.present(nextVC, animated: true, completion: nil)
                            }
                        }
                    }
                default:
                    break
                }
            }.disposed(by: self.disposeBag)
    }
}
