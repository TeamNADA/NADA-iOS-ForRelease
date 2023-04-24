//
//  AroundMeViewController.swift
//  NADA-iOS-forRelease
//
//  Created by Yi Joon Choi on 2023/02/28.
//
import UIKit

import RxSwift
import RxRelay
import RxCocoa
import RxGesture
import SnapKit
import Then

final class AroundMeViewController: UIViewController {

    // MARK: - Properties
    
    var viewModel: AroundMeViewModel!
    private let disposeBag = DisposeBag()
    var cardsNearBy: [AroundMeResponse]? = []
    
    // MARK: - UI Components
    
    private let navigationBar = CustomNavigationBar().then {
        $0.backgroundColor = .background
    }
    private let emptyTitleLabel = UILabel().then {
        $0.text = "아직 근처에 명함이 없어요!"
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
        $0.backgroundColor = .background
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
        self.view.backgroundColor = .background
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
        aroundMeCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        aroundMeCollectionView.rx.modelSelected(AroundMeResponse.self)
            .subscribe { [weak self] model in
                guard let self = self else { return }
                if let game = model.element {
//                    let playVC = self.moduleFactory.makePlayVC(.replay, type: .disableControl, matchId: game.matchID)
//                    self.hidesBottomBarWhenPushed = true
//                    self.navigationController?.pushViewController(playVC, animated: true)
                    print("Clicked")
                }
            }.disposed(by: disposeBag)
    }
    
    private func setRegister() {
        aroundMeCollectionView.register(AroundMeCollectionViewCell.self, forCellWithReuseIdentifier: AroundMeCollectionViewCell.className)
    }
    
    func setData(cardList: [AroundMeResponse]) {
        self.cardsNearBy = cardList
        self.aroundMeCollectionView.reloadData()
    }
    
    private func bindViewModels() {
        let input = AroundMeViewModel.Input(
            viewWillAppearEvent: self.rx.methodInvoked(#selector(UIViewController.viewWillAppear)).map { _ in },
            refreshButtonTapEvent: self.rx.methodInvoked(#selector(UIViewController.viewWillAppear)).map { _ in })
        let output = self.viewModel.transform(input: input)
        
        output.cardList
                    .compactMap { $0 }
                    .withUnretained(self)
                    .subscribe { owner, list in
                        owner.setData(cardList: list)
                    }.disposed(by: self.disposeBag)
        
        output.cardList
            .bind(to: aroundMeCollectionView.rx.items(cellIdentifier: AroundMeCollectionViewCell.className, cellType: AroundMeCollectionViewCell.self)) { _, model, cell in
                cell.setData(model)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension AroundMeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = UIScreen.main.bounds.width - 48
        let height: CGFloat = 144
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 0)
    }
}

// MARK: - Network

extension AroundMeViewController {
    func cardNearByFetchWithAPI(longitude: Double, latitude: Double) {
        NearbyAPI.shared.cardNearByFetch(longitde: longitude, latitude: latitude) { response in
            switch response {
            case .success(let data):
                if let cards = data as? [AroundMeResponse] {
                    self.cardsNearBy = cards
                    print(cards)
                    self.aroundMeCollectionView.reloadData()
                }
                print("cardNearByFetchWithAPI - success")
            case .requestErr(let message):
                print("cardNearByFetchWithAPI - requestErr: \(message)")
            case .pathErr:
                print("cardNearByFetchWithAPI - pathErr")
            case .serverErr:
                print("cardNearByFetchWithAPI - serverErr")
            case .networkFail:
                print("cardNearByFetchWithAPI - networkFail")
            }
        }
    }
}
