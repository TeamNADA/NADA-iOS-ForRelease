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
    
    // MARK: - Properties
    
    private var cardUUID: String?
    private var tags: [Tag] = []
    private var keyboardOn: Bool = false
    
    private let maxLength: Int = 7
    private let disposeBag = DisposeBag()

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
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        bind()
        setLayout()
        setDelegate()
        tagFetchWithAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        if !keyboardOn {
            adjectiveTextFiled.becomeFirstResponder()
            keyboardOn = true
        }
    }
}

// MARK: - Extension

extension SendTagSheetVC {
    private func setUI() {
        view.backgroundColor = .background
        
        collectionView.backgroundColor = .background
        
        IQKeyboardManager.shared.shouldResignOnTouchOutside = false
        
        [sendTagLabel, backButton, sendButton, checkImageView, completeButton].forEach { $0.isHidden = true }
    }
    private func bind() {
        backButton.rx.tap.bind { [weak self] in
            self?.adjectiveTextFiled.isUserInteractionEnabled = true
            self?.nounTextFiled.isUserInteractionEnabled = true
            self?.setEditUIWithAnimation()
        }.disposed(by: disposeBag)
        
        sendButton.rx.tap.bind { [weak self] in
            if let request = self?.creationTagRequest {
                self?.tagCreationWithAPI(request: request) {
                    self?.setCompletedUIWithAnimation()
                }
            }
        }.disposed(by: disposeBag)
        
        completeButton.rx.tap.bind { [weak self] in
            self?.dismiss(animated: true)
        }.disposed(by: disposeBag)
        
        adjectiveTextFiled.rx.text
            .orEmpty
            .distinctUntilChanged()
            .bind(with: self) { owner, text in
                owner.countTextFieldText(text, owner.adjectiveTextFiled)
            }.disposed(by: disposeBag)
        
        nounTextFiled.rx.text
            .orEmpty
            .distinctUntilChanged()
            .bind(with: self) { owner, text in
                owner.countTextFieldText(text, owner.nounTextFiled)
            }.disposed(by: disposeBag)
    }
    private func setDelegate() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SendTagCVC.self, forCellWithReuseIdentifier: "SendTagCVC")
        
        adjectiveTextFiled.delegate = self
        nounTextFiled.delegate = self
    }
    private func setEditUIWithAnimation() {
        subtitleLabel.text = "명함을 자유롭게 표현해 보세요"
        subtitleLabel.textColor = .mainColorButtonText
        adjectiveTextFiled.becomeFirstResponder()
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: { [weak self] in
            self?.sendTagLabel.alpha = 0
            self?.sendButton.alpha = 0
            self?.backButton.alpha = 0
        }, completion: { [weak self] _ in
            self?.sendButton.isHidden = true
            self?.backButton.isHidden = true
            
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn) {
                self?.sendTagLabel.isHidden = true
                self?.subtitleLabel.isHidden = false
                self?.subtitleLabel.alpha = 1
                self?.collectionView.isHidden = false
                self?.collectionView.alpha = 1
            }
        })
    }
    private func setSendUIWithAnimation() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: { [weak self] in
            self?.subtitleLabel.alpha = 0
            self?.collectionView.alpha = 0
        }, completion: { [weak self] _ in
            self?.subtitleLabel.isHidden = true
            self?.collectionView.isHidden = true
            
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn) {
                self?.sendTagLabel.isHidden = false
                self?.sendTagLabel.alpha = 1
                self?.backButton.isHidden = false
                self?.backButton.alpha = 1
                self?.sendButton.isHidden = false
                self?.sendButton.alpha = 1
            }
        })
    }
    private func setCompletedUIWithAnimation() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: { [weak self] in
            self?.sendTagLabel.alpha = 0
            self?.backButton.alpha = 0
            self?.sendButton.alpha = 0
            self?.colorView.alpha = 0
        }, completion: { [weak self] _ in
            self?.backButton.isHidden = true
            self?.sendButton.isHidden = true
            self?.colorView.isHidden = true
            
            let attributeString = NSMutableAttributedString(string: "ID \(self?.cardUUID ?? "") 명함에 태그를 보냈어요!")
            attributeString.addAttribute(.font, value: UIFont.textBold01, range: NSRange(location: 0, length: 2))
            attributeString.addAttribute(.font, value: UIFont.textRegular03, range: NSRange(location: 2, length: attributeString.length - 2))
            
            self?.sendTagLabel.attributedText = attributeString
            
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn) {
                self?.sendTagLabel.alpha = 1.0
                self?.checkImageView.isHidden = false
                self?.checkImageView.alpha = 1.0
                self?.completeButton.isHidden = false
                self?.completeButton.alpha = 1.0
            }
        })
    }
    private func countTextFieldText(_ text: String, _ textField: UITextField) {
        if text.count > maxLength {
            let maxIndex = text.index(text.startIndex, offsetBy: maxLength)
            let newString = String(text[text.startIndex..<maxIndex])
            textField.text = newString
        }
    }
    public func setCardUUID(_ cardUUID: String) {
        self.cardUUID = cardUUID
    }
}

// MARK: - Network

extension SendTagSheetVC {
    private func tagFetchWithAPI() {
        TagAPI.shared.tagFetch().subscribe(onSuccess: { [weak self] networkResult in
            switch networkResult {
            case .success(let response):
                print("tagFetchWithAPI - success")
                
                if let data = response.data {
                    self?.tags = data
                    DispatchQueue.main.async {
                        self?.collectionView.reloadData()
                        
                        self?.collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .left)
                        self?.collectionView(self?.collectionView ?? UICollectionView(), didSelectItemAt: IndexPath(item: 0, section: 0))
                    }
                }
            case .requestErr:
                print("tagFetchWithAPI - requestErr")
            case .pathErr:
                print("tagFetchWithAPI - pathErr")
            case .serverErr:
                print("tagFetchWithAPI - serverErr")
            case .networkFail:
                print("tagFetchWithAPI - networkFail")
            }
        }, onFailure: { error in
            print("tagFetchWithAPI - error: \(error)")
        }).disposed(by: disposeBag)
    }
    private func tagFilteringWithAPI(request: CreationTagRequest, completion: @escaping () -> Void) {
    }
    private func tagCreationWithAPI(request: CreationTagRequest, completion: @escaping () -> Void) {
        TagAPI.shared.tagCreation(request: request).subscribe(onSuccess: { [weak self] networkResult in
            switch networkResult {
            case .success:
                print("tagCreationWithAPI - success")
                
                completion()
            case .requestErr:
                print("tagCreationWithAPI - requestErr")
            case .pathErr:
                print("tagCreationWithAPI - pathErr")
            case .serverErr:
                print("tagCreationWithAPI - serverErr")
            case .networkFail:
                print("tagCreationWithAPI - networkFail")
            }
        }, onFailure: { error in
            print("tagCreationWithAPI - error: \(error)")
        })
        .disposed(by: disposeBag)
    }
}

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
