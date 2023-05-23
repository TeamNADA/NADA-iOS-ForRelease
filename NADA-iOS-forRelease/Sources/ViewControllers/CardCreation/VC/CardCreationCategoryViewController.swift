//
//  CardCreationCategoryViewController.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2023/02/20.
//

import UIKit

import FirebaseAnalytics
import SnapKit
import RxSwift
import RxCocoa

class CardCreationCategoryViewController: UIViewController {
    
    // MARK: - Components
    
    private let navigationBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .background
        
        return view
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "iconArrow"), for: .normal)
        
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "명함 만들기"
        label.textColor = .primary
        label.font = .title02
        
        return label
    }()
    
    private let basicBackgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        
        return view
    }()
    
    private let basicTextlabel: UILabel = {
        let label = UILabel()
        label.text = "기본"
        label.textColor = .primary
        label.font = .title02
        
        return label
    }()
    
    private let basicImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icnBasic")
        
        return imageView
    }()
    
    private let companyBackgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        
        return view
    }()
    
    private let companyTextlabel: UILabel = {
        let label = UILabel()
        label.text = "직장"
        label.textColor = .primary
        label.font = .title02
        
        return label
    }()
    
    private let companyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icnOffice")
        
        return imageView
    }()
    
    private let fanBackgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        
        return view
    }()
    
    private let fanTextlabel: UILabel = {
        let label = UILabel()
        label.text = "덕질"
        label.textColor = .primary
        label.font = .title02
        
        return label
    }()
    
    private let fanImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icnFan")
        
        return imageView
    }()
    
    private let checkMarkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "iconDone")
        
        return imageView
    }()
    
    private let contentTextlabel: UILabel = {
        let label = UILabel()
        label.text = """
                    다크모드를 켜고 아이콘의 재미있는 포인트를 찾아보세요👀
                    (더보기 > 다크모드 스위치 활성화)
                    """
        label.numberOfLines = 2
        label.textColor = .mainColorButtonText
        label.font = .textRegular05
        
        return label
    }()
    
    var viewModel = CardCreationCategoryViewModel()
    private var disposeBag = DisposeBag()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        setAddTargets()
        navigationBackSwipeMotion()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setTracking()
    }
}

// MARK: - Extension

extension CardCreationCategoryViewController {
    private func setUI() {
        view.backgroundColor = .background
        basicBackgroundView.backgroundColor = .cardCreationUnclicked
        companyBackgroundView.backgroundColor = .cardCreationUnclicked
        fanBackgroundView.backgroundColor = .cardCreationUnclicked
        
        if UITraitCollection.current.userInterfaceStyle == .light {
            contentTextlabel.isHidden = false
            checkMarkImageView.isHidden = false
        } else {
            contentTextlabel.isHidden = true
            checkMarkImageView.isHidden = true
        }
        
    }
    
    private func setAddTargets() {
        backButton.addTarget(self, action: #selector(touchBackButton), for: .touchUpInside)
    }
    
    private func navigationBackSwipeMotion() {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }

    private func bindViewModel() {
        let basicTapGesture = UITapGestureRecognizer()
        basicBackgroundView.addGestureRecognizer(basicTapGesture)
        
        let companyTapGesture = UITapGestureRecognizer()
        companyBackgroundView.addGestureRecognizer(companyTapGesture)
        
        let fanTapGesture = UITapGestureRecognizer()
        fanBackgroundView.addGestureRecognizer(fanTapGesture)
        
        let input = CardCreationCategoryViewModel.Input(touchBasic: basicTapGesture.rx.event,
                                                        touchcompany: companyTapGesture.rx.event,
                                                        touchfan: fanTapGesture.rx.event)
        let output = viewModel.transform(input: input)
        
        output.touchBasic
            .bind(with: self, onNext: { owner, _ in
                owner.basicBackgroundView.backgroundColor = .cardCreationClicked
                owner.presentToBasicCardCreationViewController()
                
                Analytics.logEvent(Tracking.Event.touchBasicCategory, parameters: nil)
            })
            .disposed(by: disposeBag)
        
        output.touchcompany
            .bind(with: self, onNext: { owner, _ in
                owner.companyBackgroundView.backgroundColor = .cardCreationClicked
                owner.presentTocompanyCardCreationViewController()
                
                Analytics.logEvent(Tracking.Event.touchCompanyCategory, parameters: nil)
            })
            .disposed(by: disposeBag)

        output.touchfan
            .bind(with: self, onNext: { owner, _ in
                owner.fanBackgroundView.backgroundColor = .cardCreationClicked
                owner.presentTofanCardCreationViewController()
                
                Analytics.logEvent(Tracking.Event.touchFanCategory, parameters: nil)
            })
            .disposed(by: disposeBag)
    }
    
    private func presentToBasicCardCreationViewController() {
        let navigationController = ModuleFactory.shared.makeCardCreationVC(cardType: .basic)
        self.navigationController?.present(navigationController, animated: true)
    }
    
    private func presentTocompanyCardCreationViewController() {
        let navigationController = ModuleFactory.shared.makeCardCreationVC(cardType: .company)
        self.navigationController?.present(navigationController, animated: true)
    }
    
    private func presentTofanCardCreationViewController() {
        let navigationController = ModuleFactory.shared.makeCardCreationVC(cardType: .fan)
        self.navigationController?.present(navigationController, animated: true)
    }
    
    private func setTracking() {
        Analytics.logEvent(AnalyticsEventScreenView,
                           parameters: [
                            AnalyticsParameterScreenName: Tracking.Screen.createCardCategory
                           ])
    }
    
    // MARK: - @objc methods

    @objc
    private func touchBackButton() {
        self.navigationController?.popViewController(animated: true)
        
        Analytics.logEvent(Tracking.Event.touchCreateCardCategoryBack, parameters: nil)
    }
}

// MARK: - Layout

extension CardCreationCategoryViewController {
    private func setLayout() {
        view.addSubviews([navigationBarView, basicBackgroundView, companyBackgroundView, fanBackgroundView, checkMarkImageView, contentTextlabel])
        navigationBarView.addSubviews([backButton, titleLabel])
        basicBackgroundView.addSubviews([basicTextlabel, basicImageView])
        companyBackgroundView.addSubviews([companyTextlabel, companyImageView])
        fanBackgroundView.addSubviews([fanTextlabel, fanImageView])
        
        navigationBarView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(50)
        }
        
        backButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(24)
            make.height.width.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.centerX.equalToSuperview()
        }
        
        basicBackgroundView.snp.makeConstraints { make in
            make.bottom.equalTo(view.snp.centerY).offset(-63)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(basicBackgroundView.snp.width).multipliedBy(117.0 / 327.0)
        }
        
        basicTextlabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(18)
            make.bottom.equalToSuperview().inset(14)
        }
        
        basicImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(24)
            make.top.equalToSuperview().inset(11)
            make.bottom.equalToSuperview().inset(9)
            make.width.equalTo(basicImageView.snp.height).multipliedBy(118.0 / 97.0)
        }
        
        fanBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(basicBackgroundView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(fanBackgroundView.snp.width).multipliedBy(117.0 / 327.0)
        }
        
        fanTextlabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(18)
            make.bottom.equalToSuperview().inset(14)
        }
        
        fanImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(24)
            make.top.equalToSuperview().inset(11)
            make.bottom.equalToSuperview().inset(9)
            make.width.equalTo(fanImageView.snp.height).multipliedBy(118.0 / 97.0)
        }
        
        companyBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(fanBackgroundView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(companyBackgroundView.snp.width).multipliedBy(117.0 / 327.0)
        }
        
        companyTextlabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(18)
            make.bottom.equalToSuperview().inset(14)
        }
        
        companyImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(24)
            make.top.equalToSuperview().inset(11)
            make.bottom.equalToSuperview().inset(9)
            make.width.equalTo(companyImageView.snp.height).multipliedBy(118.0 / 97.0)
        }
        
        checkMarkImageView.snp.makeConstraints { make in
            make.top.equalTo(companyBackgroundView.snp.bottom).offset(10)
            make.leading.equalToSuperview().inset(24)
        }
        
        contentTextlabel.snp.makeConstraints { make in
            make.leading.equalTo(checkMarkImageView.snp.trailing).offset(5)
            make.top.equalTo(checkMarkImageView).offset(3)
        }
    }
}
