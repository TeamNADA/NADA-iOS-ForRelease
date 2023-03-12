//
//  AroundMeViewController.swift
//  NADA-iOS-forRelease
//
//  Created by Yi Joon Choi on 2023/02/28.
//

import RxSwift
import RxRelay
import RxCocoa
import RxGesture
import SnapKit
import Then
import UIKit

final class AroundMeViewController: UIViewController {

    // MARK: - Properties
    
    var viewModel: AroundMeViewModel!
    private let disposeBag = DisposeBag()
    
    // MARK: - UI Components
    
    private let navigationBar = CustomNavigationBar()
    private let emptyTitleLabel = UILabel().then {
        $0.text = "아직 근처에 명함이 없어요."
        $0.font = .textBold02
        $0.textColor = .quaternary
        $0.sizeToFit()
    }
    private let emptyDescLabel = UILabel().then {
        $0.text = "명함 앞면 > 상단의 ‘공유' > 명함 활성화 버튼으로\n명함을 공유해 보세요."
        $0.numberOfLines = 2
        $0.font = .textRegular05
        $0.textColor = .quaternary
        $0.textAlignment = .center
    }
    private let emptyStackView = UIStackView().then {
        $0.spacing = 9
        $0.axis = .vertical
        $0.alignment = .center
    }
    private let aroundMeCollectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.estimatedItemSize = .zero
    }
    private lazy var aroundMeCollectionView = UICollectionView(frame: .zero, collectionViewLayout: aroundMeCollectionViewFlowLayout).then {
        $0.showsHorizontalScrollIndicator = false
        $0.clipsToBounds = false
        $0.backgroundColor = .blue
    }
    
    // MARK: - View Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setLayout()
        setDelegate()
        setRegister()
        bindViewModels()
    }

}

extension AroundMeViewController {
    
    // MARK: - UI & Layout
    
    private func setUI() {
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.isHidden = true
        navigationBar.setUI("내 근처의 명함", leftImage: UIImage(named: "iconClear"), rightImage: UIImage(named: "iconRefreshLocation"))
        navigationBar.leftButtonAction = {
          self.dismiss(animated: true)
        }
        navigationBar.rightButtonAction = {
          print("리프레시")
        }
    }
    
    private func setLayout() {
        view.addSubviews([navigationBar, emptyStackView, aroundMeCollectionView])
        emptyStackView.addArrangedSubviews([emptyTitleLabel, emptyDescLabel])
        
        navigationBar.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(50)
        }
        emptyStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(57)
        }
        aroundMeCollectionView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    // MARK: - Methods
    
    private func setDelegate() {
        aroundMeCollectionView.dataSource = self
//        aroundMeCollectionView.delegate = self
    }
    
    private func setRegister() {
        aroundMeCollectionView.register(AroundMeCollectionViewCell.self, forCellWithReuseIdentifier: AroundMeCollectionViewCell.className)
    }
    
    private func bindViewModels() {
        let input = AroundMeViewModel.Input(
            viewDidLoadEvent: self.rx.methodInvoked(#selector(UIViewController.viewWillAppear)).map { _ in },
            refreshButtonTapEvent: self.rx.methodInvoked(#selector(UIViewController.viewWillAppear)).map { _ in })
        //        let output = self.viewModel.transform(from: input, disposeBag: self.disposeBag)
        
        //TODO: 서버 연결 뒤 rx binding
        
        aroundMeCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension AroundMeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width: CGFloat = UIScreen.main.bounds.width - 48
        var height: CGFloat = 144
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 0)
    }
}

// MARK: - UICollectionViewDataSource

extension AroundMeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = viewModel.dummyList
        guard let cardCell = collectionView.dequeueReusableCell(withReuseIdentifier: AroundMeCollectionViewCell.className, for: indexPath) as? AroundMeCollectionViewCell else { return UICollectionViewCell()}
        cardCell.setData(model[indexPath.row])
        return cardCell
    }
}
