//
//  SendTagSheetVC.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2023/10/04.
//

import UIKit

import Moya
import RxCocoa
import RxSwift
import SnapKit
import Then
import IQKeyboardManagerSwift

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
        $0.textColor = .white
        $0.font = .title02
        $0.tintColor = .white
        $0.attributedPlaceholder = NSAttributedString(string: "형용사", attributes: [.foregroundColor: UIColor.white.withAlphaComponent(0.3), .font: UIFont.title02])
        $0.returnKeyType = .done
    }
    private let nounTextFiled = UITextField().then {
        $0.textAlignment = .center
        $0.textColor = .white
        $0.font = .title01
        $0.tintColor = .white
        $0.attributedPlaceholder = NSAttributedString(string: "명사", attributes: [.foregroundColor: UIColor.white.withAlphaComponent(0.3), .font: UIFont.title01])
        $0.returnKeyType = .done
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
    private lazy var sendTagLabel = UILabel().then {
        let attributeString = NSMutableAttributedString(string: "ID \(cardUUID ?? "") 명함에 태그를 보낼까요?")
        attributeString.addAttribute(.font, value: UIFont.textBold01, range: NSRange(location: 0, length: 2))
        attributeString.addAttribute(.font, value: UIFont.textRegular03, range: NSRange(location: 2, length: attributeString.length - 2))
        
        $0.attributedText = attributeString
        $0.textColor = .secondary
        $0.alpha = 0
    }
    private let sendButton = UIButton().then {
        $0.backgroundColor = .mainColorNadaMain
        $0.setTitleColor(.white, for: .normal)
        $0.setTitle("보내기", for: .normal)
        $0.titleLabel?.font = .button01
        $0.layer.cornerRadius = 15
        $0.alpha = 0
    }
    private let backButton = UIButton().then {
        $0.backgroundColor = .button
        $0.setTitleColor(.tertiary, for: .normal)
        $0.setTitle("뒤로가기", for: .normal)
        $0.titleLabel?.font = .button01
        $0.layer.cornerRadius = 15
        $0.alpha = 0
    }
    private let completeButton = UIButton().then {
        $0.backgroundColor = .mainColorNadaMain
        $0.setTitleColor(.white, for: .normal)
        $0.setTitle("완료", for: .normal)
        $0.titleLabel?.font = .button01
        $0.layer.cornerRadius = 15
        $0.alpha = 0
    }
    private let checkImageView = UIImageView().then {
        $0.image = UIImage(named: "imgCheckDone")
        $0.alpha = 0
    }
    
    // MARK: - Properties
    
    private var cardUUID: String?
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
        
        adjectiveTextFiled.delegate = self
        nounTextFiled.delegate = self
    }
    public func setCardUUID(_ cardUUID: String) {
        self.cardUUID = cardUUID
    }
    }
}

    /*
    // MARK: - Navigation
// MARK: - Layout

extension SendTagSheetVC {
    private func setLayout() {
        view.addSubviews([grabber, titleLabel, subtitleLabel, colorView, collectionView, sendTagLabel, backButton, sendButton, checkImageView, completeButton])
        
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
        sendTagLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(191)
            make.centerX.equalToSuperview()
        }
        backButton.snp.makeConstraints { make in
            make.top.equalTo(sendTagLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().inset(24)
            make.right.equalTo(view.snp.centerX).inset(3.5)
            make.height.equalTo(54)
        }
        sendButton.snp.makeConstraints { make in
            make.top.equalTo(sendTagLabel.snp.bottom).offset(20)
            make.right.equalToSuperview().inset(24)
            make.left.equalTo(view.snp.centerX).offset(3.5)
            make.height.equalTo(54)
        }
        checkImageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(45)
            make.centerX.equalToSuperview()
        }
        completeButton.snp.makeConstraints { make in
            make.top.equalTo(sendTagLabel.snp.bottom).offset(20)
            make.right.left.equalToSuperview().inset(24)
            make.height.equalTo(54)
        }
        
        colorView.addSubviews([iconImageView, adjectiveTextFiled, nounTextFiled])
        
        iconImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(9)
            make.centerX.equalToSuperview()
        }
        adjectiveTextFiled.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(17)
            make.left.right.equalToSuperview().inset(12.5)
        }
        nounTextFiled.snp.makeConstraints { make in
            make.top.equalTo(adjectiveTextFiled.snp.bottom).offset(8)
            make.left.right.equalToSuperview().inset(12.5)
        }
    }
}

// MARK: - UICollectionViewDelegate

extension SendTagSheetVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        iconImageView.image = UIImage(named: tags[indexPath.item].icon)
        
        if #available(iOS 13, *) {
            if traitCollection.userInterfaceStyle == .light {
                colorView.backgroundColor = UIColor(red: CGFloat(tags[indexPath.item].lr) / 255.0, green: CGFloat(tags[indexPath.item].lg) / 255.0, blue: CGFloat(tags[indexPath.item].lb) / 255.0, alpha: 1.0)
            } else {
                colorView.backgroundColor = UIColor(red: CGFloat(tags[indexPath.item].dr) / 255.0, green: CGFloat(tags[indexPath.item].dg) / 255.0, blue: CGFloat(tags[indexPath.item].db) / 255.0, alpha: 1.0)
            }
        } else {
            colorView.backgroundColor = UIColor(red: CGFloat(tags[indexPath.item].lr) / 255.0, green: CGFloat(tags[indexPath.item].lg) / 255.0, blue: CGFloat(tags[indexPath.item].lb) / 255.0, alpha: 1.0)
        }
    }
}

// MARK: - UICollectionViewDataSource
extension SendTagSheetVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SendTagCVC", for: indexPath) as? SendTagCVC else { return UICollectionViewCell() }
        
        cell.initCell(tags[indexPath.item].lr,
                      tags[indexPath.item].lg,
                      tags[indexPath.item].lb,
                      tags[indexPath.item].dr,
                      tags[indexPath.item].dg,
                      tags[indexPath.item].db)
        
        return cell
    }
}

// MARK: - UITextFieldDelegate

extension SendTagSheetVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let adjectiveText = adjectiveTextFiled.text, let nounText = nounTextFiled.text,
           !adjectiveText.isEmpty, !nounText.isEmpty {
            if let items = collectionView.indexPathsForSelectedItems?.map({ index in index.item }) {
                creationTagRequest = .init(adjective: adjectiveText, cardUUID: cardUUID ?? "", icon: tags[items[0]].icon, noun: nounText)

                tagFilteringWithAPI(request: CreationTagRequest(adjective: adjectiveText,
                                                                cardUUID: cardUUID ?? "",
                                                                icon: tags[items[0]].icon,
                                                                noun: nounText)) { [weak self] in
                    self?.setSendUIWithAnimation()
                }
            }
        } else {
            subtitleLabel.text = "형용사, 명사 모두를 입력해 주세요."
            subtitleLabel.textColor = .stateColorError
        }
        
        return false
    }
}
