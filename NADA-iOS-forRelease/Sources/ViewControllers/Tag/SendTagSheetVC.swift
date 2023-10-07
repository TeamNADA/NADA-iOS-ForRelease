//
//  SendTagSheetVC.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2023/10/04.
//

import UIKit

import RxSwift
import SnapKit
import Then

class SendTagSheetVC: UIViewController {

    // MARK: - Components
    
    private let grabber: UIImageView = UIImageView().then {
        $0.image = UIImage(named: "iconBottomSheet")
    }
    private let titleLabel: UILabel = UILabel().then {
        $0.text = "태그 보내기"
        $0.font = .title01
        $0.textColor = .primary
    }
    private let subtitleLabel = UILabel().then {
        $0.text = "명함을 자유롭게 표현해 보세요"
        $0.textColor = .mainColorButtonText
        $0.font = .textRegular05
    }
    private let colorView = UIView().then {
        $0.layer.cornerRadius = 15
    }
    private let iconImageView = UIImageView()
    private let adjectiveTextFiled = UITextField().then {
        $0.textAlignment = .center
        $0.text = "형용사"
        $0.font = .title02
        $0.textColor = .white.withAlphaComponent(0.3)
    }
    private let nounTextFiled = UITextField().then {
        $0.textAlignment = .center
        $0.text = "명사"
        $0.font = .title01
        $0.textColor = .white.withAlphaComponent(0.3)
    }
    private let collectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.estimatedItemSize = .zero
        $0.minimumLineSpacing = 21
        $0.minimumInteritemSpacing = 0
        $0.itemSize = .init(width: 32, height: 32)
        $0.scrollDirection = .horizontal
    }
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout).then {
        $0.showsHorizontalScrollIndicator = false
    }
    
    // MARK: - Properties
    
    private var tags: [Tag] = []
    private let disposeBag = DisposeBag()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setLayout()
        setDelegate()
    }
    

// MARK: - Extension

extension SendTagSheetVC {
    private func setUI() {
        view.backgroundColor = .background
        
        collectionView.backgroundColor = .background
    }
    private func setDelegate() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SendTagCVC.self, forCellWithReuseIdentifier: "SendTagCVC")
    }
}

    /*
    // MARK: - Navigation
// MARK: - Layout

extension SendTagSheetVC {
    private func setLayout() {
        view.addSubviews([grabber, titleLabel, subtitleLabel, colorView, collectionView])
        
        grabber.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.centerX.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(47)
            make.centerX.equalToSuperview()
        }
        subtitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(7)
            make.centerX.equalToSuperview()
        }
        colorView.snp.makeConstraints { make in
            make.top.equalTo(subtitleLabel.snp.bottom).offset(14)
            make.height.equalTo(132)
            make.left.right.equalToSuperview().inset(41)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(colorView.snp.bottom).offset(16)
            make.left.right.equalToSuperview().inset(39)
            make.height.equalTo(32)
        }
        
        colorView.addSubviews([iconImageView, adjectiveTextFiled, nounTextFiled])
        
        iconImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(9)
            make.centerX.equalToSuperview()
        }
        adjectiveTextFiled.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(17)
            make.centerX.equalToSuperview()
        }
        nounTextFiled.snp.makeConstraints { make in
            make.top.equalTo(adjectiveTextFiled.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
    }
}

    }
    */

}
