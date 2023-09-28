//
//  FetchTagSheetVC.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2023/09/13.
//

import UIKit

import Moya
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
    
    private var cardUUID: String?
    private var receivedTagList: [ReceivedTag]?
    
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
        collectionView.dataSource = self
        collectionView.register(TagCVC.self, forCellWithReuseIdentifier: "TagCVC")
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

// MARK: - UICollectionViewDataSource

extension FetchTagSheetVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return receivedTagList?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagCVC", for: indexPath) as? TagCVC, let receivedTagList else { return UICollectionViewCell() }
        
        cell.initCell(receivedTagList[indexPath.item].adjective,
                      receivedTagList[indexPath.item].noun,
                      receivedTagList[indexPath.item].icon,
                      receivedTagList[indexPath.item].lr,
                      receivedTagList[indexPath.item].lg,
                      receivedTagList[indexPath.item].lb,
                      receivedTagList[indexPath.item].dr,
                      receivedTagList[indexPath.item].dg,
                      receivedTagList[indexPath.item].db)
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension FetchTagSheetVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 6
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
        let tagProvider = MoyaProvider<TagService>(plugins: [MoyaLoggerPlugin()])
        
        tagProvider.rx.request(.receivedTagFetch(cardUUID: self.cardUUID ?? ""))
            .subscribe { [weak self] event in
                switch event {
                case .success(let response):
                    let decoder = JSONDecoder()
                    guard let decodedData = try? decoder.decode(GenericResponse<[ReceivedTag]>.self, from: response.data) else {
                        print("receivedTagFetchWithAPI - pathErr")
                        return
                    }
                    
                    switch decodedData.status {
                    case 200..<300:
                        print("receivedTagFetchWithAPI - success")
                        
                        self?.receivedTagList = decodedData.data
                        DispatchQueue.main.async {
                            self?.collectionView.reloadData()
                        }
                    case 400..<500:
                        print("receivedTagFetchWithAPI - requestErr")
                    case 500:
                        print("receivedTagFetchWithAPI - serverErr")
                    default:
                        print("receivedTagFetchWithAPI - networkFail")
                    }
                case .failure(let error):
                    print(error)
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
            make.bottom.equalToSuperview().inset(73)
        }
    }
}
