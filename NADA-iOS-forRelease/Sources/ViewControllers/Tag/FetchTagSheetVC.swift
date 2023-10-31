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
        $0.setTitle("편집", for: .normal)
        $0.titleLabel?.font = .button02
        $0.setTitleColor(.primary, for: .normal)
        $0.setTitleColor(.quaternary, for: .disabled)
    }
    private let collectionViewFlowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.estimatedItemSize = .zero
    }
    private lazy var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout).then {
        $0.showsVerticalScrollIndicator = false
        $0.allowsMultipleSelection = true
    }
    private let emptyView = UIImageView(image: UIImage(named: "imgSendTagEmpty")).then {
        $0.isHidden = true
    }
    
    // MARK: - Properties
    
    private enum Mode {
        case fetch
        case edit
    }
    
    private var cardUUID: String?
    private var receivedTags: [ReceivedTag]?
    private var diffableDataSource: UICollectionViewDiffableDataSource<Section, ReceivedTag>?
    private var mode: Mode = .fetch
    
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
        
        collectionView.backgroundColor = .background
    }
    private func setAction() {
        cancelButton.rx.tap
            .bind(with: self) { owner, _ in
                owner.collectionView.reloadData()
                owner.cancelButton.isHidden = true
                owner.deleteButton.setTitle("편집", for: .normal)
                owner.deleteButton.setTitleColor(.primary, for: .normal)
                owner.deleteButton.isEnabled = true
                
                owner.mode = .fetch
            }
            .disposed(by: disposeBag)
        
        deleteButton.rx.tap
            .bind(with: self) { owner, _ in
                switch owner.mode {
                case .fetch:
                    owner.deleteButton.setTitle("삭제", for: .normal)
                    owner.deleteButton.setTitleColor(.stateColorError, for: .normal)
                    owner.deleteButton.isEnabled = false
                    owner.cancelButton.isHidden = false
                    
                    owner.mode = .edit
                case .edit:
                    guard let selectedItems = owner.collectionView.indexPathsForSelectedItems else { return }
                    
                    var tagDeletionRequests: [TagDeletionRequest] = []
                    
                    selectedItems.map { $0.item }.forEach { item in
                        let request = TagDeletionRequest(cardTagID: owner.receivedTags?[item].cardTagID ?? 0)
                        tagDeletionRequests.append(request)
                    }
                    
                    owner.deleteTagWithAPI(request: tagDeletionRequests)
                    
                    owner.deleteButton.setTitle("편집", for: .normal)
                    owner.deleteButton.setTitleColor(.primary, for: .normal)
                    owner.deleteButton.isEnabled = true
                    owner.cancelButton.isHidden = true
                    
                    owner.mode = .fetch
                }
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
            if receivedTags.isEmpty {
                emptyView.isHidden = false
                deleteButton.setTitleColor(.quaternary, for: .normal)
                deleteButton.isEnabled = false
            } else {
                emptyView.isHidden = true
                deleteButton.setTitleColor(.primary, for: .normal)
                deleteButton.isEnabled = true
                
                snapshot.appendItems(receivedTags)
            }
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
        switch mode {
        case .fetch:
            collectionView.deselectItem(at: indexPath, animated: false)
        case .edit:
            deleteButton.isEnabled = true
        }
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView.indexPathsForSelectedItems?.isEmpty == true {
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
        TagAPI.shared.receivedTagFetch(cardUUID: cardUUID ?? "").subscribe(with: self, onSuccess: { owner, networkResult in
            switch networkResult {
            case .success(let response):
                print("receivedTagFetchWithAPI - success")
                
                if let data = response.data {
                    owner.receivedTags = data
                    
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
        }, onFailure: { _, error in
            print("deleteTagWithAPI - error : \(error)")
        })
        .disposed(by: disposeBag)
    }
    private func deleteTagWithAPI(request: [TagDeletionRequest]) {
        TagAPI.shared.tagDeletion(request: request).subscribe(with: self, onSuccess: { owner, networkResult in
            switch networkResult {
            case .success:
                print("deleteTagWithAPI - success")
                
                owner.receivedTagFetchWithAPI()
            case .requestErr:
                print("deleteTagWithAPI - requestErr")
            case .pathErr:
                print("deleteTagWithAPI - pathErr")
            case .serverErr:
                print("deleteTagWithAPI - serverErr")
            case .networkFail:
                print("deleteTagWithAPI - networkFail")
            }
        }, onFailure: { _, error in
            print("deleteTagWithAPI - error : \(error)")
        })
        .disposed(by: disposeBag)
    }
}

// MARK: - Layout

extension FetchTagSheetVC {
    private func setLayout() {
        view.addSubviews([grabber, titleLabel, cancelButton, deleteButton, collectionView, emptyView])
        
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
        emptyView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(166)
            make.centerX.equalToSuperview()
        }
    }
}
