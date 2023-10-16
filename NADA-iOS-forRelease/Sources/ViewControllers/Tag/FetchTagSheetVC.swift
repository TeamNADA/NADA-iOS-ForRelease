//
//  FetchTagSheetVC.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2023/09/13.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

class FetchTagSheetVC: UIViewController {

    // MARK: - Components
    
    private let grabber: UIImageView = UIImageView().then {
        $0.image = UIImage(named: "iconBottomSheet")
    }
    private let titleLabel: UILabel = UILabel().then {
        $0.text = "받은 태그"
        $0.font = .title01
        $0.textColor = .primary
    }
    private let cancelButton: UIButton = UIButton().then {
        $0.setTitle("취소", for: .normal)
        $0.titleLabel?.font = .button02
        $0.setTitleColor(.primary, for: .normal)
    }
    private let deleteButton: UIButton = UIButton().then {
        $0.setTitle("삭제", for: .normal)
        $0.titleLabel?.font = .button02
        $0.setTitleColor(.stateColorError, for: .normal)
        $0.setTitleColor(.quaternary, for: .disabled)
    }
    private let collevtionViewFlowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.estimatedItemSize = .zero
    }
    private lazy var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: collevtionViewFlowLayout).then {
        $0.showsVerticalScrollIndicator = false
        $0.allowsMultipleSelection = true
    }
    
    // MARK: - Properties
    
    private enum Section: Hashable {
        case main
    }
    private var cardUUID: String?
    private var receivedTagList: [ReceivedTag]?
    private var diffableDataSource: UICollectionViewDiffableDataSource<Section, ReceivedTag>?
    
    private let disposeBag = DisposeBag()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        setLayout()
        setAction()
        receivedTagFetchWithAPI()
        setDelegate()
    }
}

// MARK: - extension

extension FetchTagSheetVC {
    private func setUI() {
        view.backgroundColor = .background
        
        cancelButton.isHidden = true
        
        deleteButton.isEnabled = false
        
        collectionView.backgroundColor = .background
    }
    private func setAction() {
        cancelButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.collectionView.reloadData()
                owner.cancelButton.isHidden = true
            }
            .disposed(by: disposeBag)
        
        deleteButton.rx.tap
            .bind(with: self) { owner, _ in
//                owner.deleteTagWithAPI(cardUUID: "", cardTagID: 0)
                // FIXME: - 삭제 후에 조회하도록 수정
                owner.receivedTagFetchWithAPI()
                owner.cancelButton.isHidden = true
                owner.deleteButton.isEnabled = false
            }
            .disposed(by: disposeBag)
    }
    private func setDelegate() {
        collectionView.delegate = self
        collectionView.register(TagCVC.self, forCellWithReuseIdentifier: "TagCVC")
        
        diffableDataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { collectionView, indexPath, receivedTag in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCVC", for: indexPath) as? TagCVC else { return UICollectionViewCell() }
            
            cell.initCell(receivedTag.adjective,
                          receivedTag.noun,
                          receivedTag.icon,
                          receivedTag.lr,
                          receivedTag.lg,
                          receivedTag.lb,
                          receivedTag.dr,
                          receivedTag.dg,
                          receivedTag.db)
            
            return cell
        }
        
        collectionView.dataSource = diffableDataSource
    }
    private func setCollectionView() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ReceivedTag>()
        
        snapshot.appendSections([.main])
        
        if let receivedTags {
            snapshot.appendItems(receivedTags)
        }
        
        diffableDataSource?.apply(snapshot, animatingDifferences: true)
    }
    public func setCardUUID(_ cardUUID: String) {
        self.cardUUID = cardUUID
    }
}

// MARK: - UICollectionViewDelegate

extension FetchTagSheetVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            cancelButton.isHidden = false
            deleteButton.isEnabled = true
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView.indexPathsForSelectedItems?.isEmpty == true {
            cancelButton.isHidden = true
            deleteButton.isEnabled = false
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension FetchTagSheetVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let safeAreaBottom = windowScene?.windows.first?.safeAreaInsets.bottom ?? 0
        
        return UIEdgeInsets(top: 0, left: 0, bottom: safeAreaBottom + 39, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.width / 327 * 48)
    }
}

// MARK: - Network

extension FetchTagSheetVC {
    private func receivedTagFetchWithAPI() {
        TagAPI.shared.receivedTagFetch(cardUUID: cardUUID ?? "").subscribe(with: self) { owner, event in
            switch event {
            case .success(let data):
                print("receivedTagFetchWithAPI - success")
                
                if let data {
                    owner.receivedTagList = data
                    DispatchQueue.main.async {
                        owner.setCollectionView()
                    }
                }
            case .requestErr:
                print("receivedTagFetchWithAPI - requestErr")
            case .pathErr:
                print("receivedTagFetchWithAPI - pathErr")
            case .serverErr:
                print("receivedTagFetchWithAPI - serverErr")
            case .networkFail:
                print("receivedTagFetchWithAPI - networkFail")
            }
        }
        .disposed(by: disposeBag)
    }
    private func deleteTagWithAPI(cardUUID: String, cardTagID: Int) {
        
    }
}

// MARK: - Layout

extension FetchTagSheetVC {
    private func setLayout() {
        view.addSubviews([grabber, titleLabel, cancelButton, deleteButton, collectionView])
        
        grabber.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.centerX.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(47)
            make.centerX.equalToSuperview()
        }
        cancelButton.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(24)
            make.centerY.equalTo(titleLabel)
        }
        deleteButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(24)
            make.centerY.equalTo(titleLabel)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(24)
            make.bottom.equalToSuperview()
        }
    }
}
