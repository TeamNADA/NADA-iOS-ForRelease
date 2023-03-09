//
//  CardCreationCategoryViewController.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2023/02/20.
//

import SnapKit
import RxSwift
import RxCocoa

import UIKit

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
    
    private let jobBackgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        
        return view
    }()
    
    private let jobTextlabel: UILabel = {
        let label = UILabel()
        label.text = "직장"
        label.textColor = .primary
        label.font = .title02
        
        return label
    }()
    
    private let jobImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "icnOffice")
        
        return imageView
    }()
    
    private let diggingBackgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        
        return view
    }()
    
    private let diggingTextlabel: UILabel = {
        let label = UILabel()
        label.text = "덕질"
        label.textColor = .primary
        label.font = .title02
        
        return label
    }()
    
    private let diggingImageView: UIImageView = {
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
}

// MARK: - Extension

extension CardCreationCategoryViewController {
    private func setUI() {
        view.backgroundColor = .background
        basicBackgroundView.backgroundColor = .cardCreationUnclicked
        jobBackgroundView.backgroundColor = .cardCreationUnclicked
        diggingBackgroundView.backgroundColor = .cardCreationUnclicked
    }
    
    private func setAddTargets() {
        backButton.addTarget(self, action: #selector(touchBackButton), for: .touchUpInside)
    }
    
    private func navigationBackSwipeMotion() {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }

    private func bindViewModel() {
        
        // TODO: - RxGesture 로 리펙토링 하기.
        let basicTapGesture = UITapGestureRecognizer()
        basicBackgroundView.addGestureRecognizer(basicTapGesture)
        
        let jobTapGesture = UITapGestureRecognizer()
        jobBackgroundView.addGestureRecognizer(jobTapGesture)
        
        let diggingTapGesture = UITapGestureRecognizer()
        diggingBackgroundView.addGestureRecognizer(diggingTapGesture)
        
        let input = CardCreationCategoryViewModel.Input(touchBasic: basicTapGesture.rx.event,
                                                        touchJob: jobTapGesture.rx.event,
                                                        touchDigging: diggingTapGesture.rx.event)
        let output = viewModel.transform(input: input)
        
        output.touchBasic
            .bind(with: self, onNext: { owner, _ in
                owner.basicBackgroundView.backgroundColor = .cardCreationClicked
                owner.presentToBasicCardCreationViewController()
            })
            .disposed(by: disposeBag)
        
        output.touchJob
            .bind(with: self, onNext: { owner, _ in
                owner.jobBackgroundView.backgroundColor = .cardCreationClicked
                owner.presentToJobCardCreationViewController()
            })
            .disposed(by: disposeBag)

        output.touchDigging
            .bind(with: self, onNext: { owner, _ in
                owner.diggingBackgroundView.backgroundColor = .cardCreationClicked
                owner.presentToDiggingCardCreationViewController()
            })
            .disposed(by: disposeBag)
    }
    
    // TODO: - 화면전환 메서드 작성.
    private func presentToBasicCardCreationViewController() {
        guard let nextVC = UIStoryboard(name: Const.Storyboard.Name.cardCreation, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.cardCreationViewController) as? CardCreationViewController else { return }
        let navigationController = UINavigationController(rootViewController: nextVC)
        navigationController.modalPresentationStyle = .fullScreen
        self.navigationController?.present(navigationController, animated: true)
    }
    
    private func presentToJobCardCreationViewController() {
        
    }
    
    private func presentToDiggingCardCreationViewController() {
        
    }
    
    // MARK: - @objc methods

    @objc
    private func touchBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - Layout

extension CardCreationCategoryViewController {
    private func setLayout() {
        view.addSubviews([navigationBarView, basicBackgroundView, jobBackgroundView, diggingBackgroundView, checkMarkImageView, contentTextlabel])
        navigationBarView.addSubviews([backButton, titleLabel])
        basicBackgroundView.addSubviews([basicTextlabel, basicImageView])
        jobBackgroundView.addSubviews([jobTextlabel, jobImageView])
        diggingBackgroundView.addSubviews([diggingTextlabel, diggingImageView])
        
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
        }
        
        jobBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(basicBackgroundView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(basicBackgroundView.snp.width).multipliedBy(117.0 / 327.0)
        }
        
        jobTextlabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(18)
            make.bottom.equalToSuperview().inset(14)
        }
        
        jobImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(24)
            make.top.equalToSuperview().inset(11)
            make.bottom.equalToSuperview().inset(9)
        }
        
        diggingBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(jobBackgroundView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(basicBackgroundView.snp.width).multipliedBy(117.0 / 327.0)
        }
        
        diggingTextlabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(18)
            make.bottom.equalToSuperview().inset(14)
        }
        
        diggingImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(24)
            make.top.equalToSuperview().inset(11)
            make.bottom.equalToSuperview().inset(9)
        }
        
        checkMarkImageView.snp.makeConstraints { make in
            make.top.equalTo(diggingBackgroundView.snp.bottom).offset(10)
            make.leading.equalToSuperview().inset(24)
        }
        
        contentTextlabel.snp.makeConstraints { make in
            make.leading.equalTo(checkMarkImageView.snp.trailing).offset(5)
            make.top.equalTo(checkMarkImageView).offset(3)
        }
    }
}
