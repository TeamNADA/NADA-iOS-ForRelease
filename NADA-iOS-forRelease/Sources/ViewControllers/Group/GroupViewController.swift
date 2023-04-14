//
//  GroupViewController.swift
//  NADA-iOS-forRelease
//
//  Created by 민 on 2021/10/08.
//

import Photos
import UIKit
import Kingfisher
import NVActivityIndicatorView

class GroupViewController: UIViewController {
    
    // MARK: - Properties
    // 네비게이션 바
    @IBAction func presentToAddWithIdView(_ sender: Any) {
        let nextVC = AddWithIdBottomSheetViewController()
                    .setTitle("ID로 명함 추가")
                    .setHeight(184)
        nextVC.modalPresentationStyle = .overFullScreen
        self.present(nextVC, animated: false, completion: nil)
    }
    
    @IBAction func presentToAddWithQrView(_ sender: Any) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .denied:
            makeOKCancelAlert(title: "카메라 권한이 허용되어 있지 않아요.",
                        message: "QR코드 인식을 위해 카메라 권한이 필요합니다. 앱 설정으로 이동해 허용해 주세요.",
                        okAction: { _ in UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)},
                        cancelAction: nil,
                        completion: nil)
        case .authorized:
            guard let nextVC = UIStoryboard.init(name: Const.Storyboard.Name.qrScan, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.qrScanViewController) as? QRScanViewController else { return }
            nextVC.modalPresentationStyle = .overFullScreen
            self.present(nextVC, animated: true, completion: nil)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    DispatchQueue.main.async {
                        guard let nextVC = UIStoryboard.init(name: Const.Storyboard.Name.qrScan, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.qrScanViewController) as? QRScanViewController else { return }
                        nextVC.modalPresentationStyle = .overFullScreen
                        self.present(nextVC, animated: true, completion: nil)
                    }
                }
            }
        default:
            break
        }
    }
    
    // 중간 그룹 이름들 나열된 뷰
    @IBAction func pushToGroupEdit(_ sender: Any) {
        guard let nextVC = UIStoryboard.init(name: Const.Storyboard.Name.groupEdit, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.groupEditViewController) as? GroupEditViewController else { return }
        nextVC.serverGroups = self.serverGroups
        
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    // MARK: - Components
    
    lazy var loadingBgView: UIView = {
        let bgView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        bgView.backgroundColor = .loadingBackground
        
        return bgView
    }()
    
    lazy var activityIndicator: NVActivityIndicatorView = {
        let activityIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40),
                                                        type: .ballBeat,
                                                        color: .mainColorNadaMain,
                                                        padding: .zero)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        return activityIndicator
    }()
    
    // collectionview
    @IBOutlet weak var groupCollectionView: UICollectionView!
    @IBOutlet weak var cardsCollectionView: UICollectionView!
    @IBOutlet weak var emptyView: UIView!
    
    // 그룹 이름들을 담을 변수 생성
    var serverGroups: Groups?
    var frontCards: [FrontCard]? = []
    var serverCardsWithBack: Card?
    var groupId: Int?
    
    var selectedRow = 0
    private var offset = 0
    private var isInfiniteScroll = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCell()
        setNotification()
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.async {
            self.setActivityIndicator()
            
            self.offset = 0
            self.frontCards?.removeAll()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.groupListFetchWithAPI(userID: UserDefaults.standard.string(forKey: Const.UserDefaultsKey.userID) ?? "")
        }
    }
}

// MARK: - Extensions

extension GroupViewController {
    private func registerCell() {
        groupCollectionView.delegate = self
        groupCollectionView.dataSource = self
        cardsCollectionView.delegate = self
        cardsCollectionView.dataSource = self
         
        groupCollectionView.register(GroupCollectionViewCell.nib(), forCellWithReuseIdentifier: Const.Xib.groupCollectionViewCell)
        cardsCollectionView.register(CardInGroupCollectionViewCell.nib(), forCellWithReuseIdentifier: Const.Xib.cardInGroupCollectionViewCell)
    }
    
    private func setUI() {
        emptyView.isHidden = true
        navigationController?.navigationBar.isHidden = true
    }
    
    private func setNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(didRecieveDataNotification(_:)), name: Notification.Name.passDataToGroup, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(relaodCardCollection), name: .reloadGroupViewController, object: nil)
    }
    
    private func setActivityIndicator() {
        view.addSubview(loadingBgView)
        loadingBgView.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        activityIndicator.startAnimating()
    }
    
    // MARK: - @objc Methods
    
    @objc func didRecieveDataNotification(_ notification: Notification) {
        selectedRow = notification.object as? Int ?? 0
    }
    
    @objc
    private func relaodCardCollection() {
        offset = 0
        frontCards?.removeAll()
        
        groupListFetchWithAPI(userID: UserDefaults.standard.string(forKey: Const.UserDefaultsKey.userID) ?? "")
    }
}

// MARK: - Network

extension GroupViewController {
    func groupListFetchWithAPI(userID: String) {
        GroupAPI.shared.groupListFetch(userID: userID) { response in
            switch response {
            case .success(let data):
                if let group = data as? Groups {
                    self.serverGroups = group
                    self.groupCollectionView.reloadData()
                    self.groupId = group.groups[self.selectedRow].groupID
                    self.cardListInGroupWithAPI(cardListInGroupRequest: CardListInGroupRequest(userId: UserDefaults.standard.string(forKey: Const.UserDefaultsKey.userID) ?? "", groupId: group.groups[self.selectedRow].groupID, offset: 0)) {
                        if self.frontCards?.count != 0 {
                            self.cardsCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
                        }
                        self.isInfiniteScroll = true
                    }
                }
            case .requestErr(let message):
                print("groupListFetchWithAPI - requestErr: \(message)")
            case .pathErr:
                print("groupListFetchWithAPI - pathErr")
            case .serverErr:
                print("groupListFetchWithAPI - serverErr")
            case .networkFail:
                print("groupListFetchWithAPI - networkFail")
            }
        }
    }
    
    func cardListInGroupWithAPI(cardListInGroupRequest: CardListInGroupRequest, completion: @escaping () -> Void = { }) {
        GroupAPI.shared.cardListFetchInGroup(cardListInGroupRequest: cardListInGroupRequest) { response in
            switch response {
            case .success(let data):
                self.activityIndicator.stopAnimating()
                self.loadingBgView.removeFromSuperview()
                
                if let cards = data as? CardsInGroupResponse {
                    self.frontCards?.append(contentsOf: cards.cards)
                    if self.frontCards?.count == 0 {
                        self.emptyView.isHidden = false
                    } else {
                        self.emptyView.isHidden = true
                    }
                    self.cardsCollectionView.reloadData()
                }
                completion()
            case .requestErr(let message):
                print("cardListInGroupWithAPI - requestErr: \(message)")
            case .pathErr:
                print("cardListInGroupWithAPI - pathErr")
            case .serverErr:
                print("cardListInGroupWithAPI - serverErr")
            case .networkFail:
                print("cardListInGroupWithAPI - networkFail")
            }
        }
    }
    
    func cardDetailFetchWithAPI(cardUUID: String) {
        CardAPI.shared.cardDetailFetch(cardUUID: cardUUID) { response in
            switch response {
            case .success(let data):
                if let card = data as? Card {
                    guard let nextVC = UIStoryboard.init(name: Const.Storyboard.Name.cardDetail, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.cardDetailViewController) as? CardDetailViewController else { return }
                    
                    nextVC.cardDataModel = card
                    nextVC.groupId = self.groupId
                    nextVC.serverGroups = self.serverGroups
                    self.navigationController?.pushViewController(nextVC, animated: true)
                }
            case .requestErr(let message):
                print("cardDetailFetchWithAPI - requestErr: \(message)")
            case .pathErr:
                print("cardDetailFetchWithAPI - pathErr")
            case .serverErr:
                print("cardDetailFetchWithAPI - serverErr")
            case .networkFail:
                print("cardDetailFetchWithAPI - networkFail")
            }
        }
    }
}

// MARK: - UICollectionViewDelegate
extension GroupViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == cardsCollectionView {
            if cardsCollectionView.contentOffset.y > cardsCollectionView.contentSize.height - cardsCollectionView.bounds.height {
                if isInfiniteScroll {
                    isInfiniteScroll = false
                    offset += 1
                    
                    cardListInGroupWithAPI(cardListInGroupRequest: CardListInGroupRequest(userId: UserDefaults.standard.string(forKey: Const.UserDefaultsKey.userID) ?? "", groupId: serverGroups?.groups[self.selectedRow].groupID ?? -1, offset: offset)) {
                        self.isInfiniteScroll = true
                    }
                }
            }
        }
    }
}

// MARK: - UICollectionViewDataSource
extension GroupViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case groupCollectionView:
            return serverGroups?.groups.count ?? 0
        case cardsCollectionView:
            return frontCards?.count ?? 0
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case groupCollectionView:
            guard let groupCell = collectionView.dequeueReusableCell(withReuseIdentifier: Const.Xib.groupCollectionViewCell, for: indexPath) as? GroupCollectionViewCell else {
                return UICollectionViewCell()
            }
            groupCell.groupName.text = serverGroups?.groups[indexPath.row].groupName
            
            if indexPath.row == selectedRow {
                collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .init())
            }
            return groupCell
        case cardsCollectionView:
            guard let cardCell = collectionView.dequeueReusableCell(withReuseIdentifier: Const.Xib.cardInGroupCollectionViewCell, for: indexPath) as? CardInGroupCollectionViewCell else {
                return UICollectionViewCell()
            }
            guard let frontCards = frontCards else { return UICollectionViewCell() }
            cardCell.backgroundImageView.updateServerImage(frontCards[indexPath.row].background)
            cardCell.cardId = frontCards[indexPath.row].cardID
            cardCell.titleLabel.text = frontCards[indexPath.row].title
            cardCell.descriptionLabel.text = frontCards[indexPath.row].cardDescription
            cardCell.userNameLabel.text = frontCards[indexPath.row].name
            cardCell.birthLabel.text = frontCards[indexPath.row].birthDate
            cardCell.mbtiLabel.text = frontCards[indexPath.row].mbti
            cardCell.instagramIDLabel.text = frontCards[indexPath.row].instagram
            cardCell.lineURLLabel.text = frontCards[indexPath.row].link
            
            if frontCards[indexPath.row].instagram == "" {
                cardCell.instagramIcon.isHidden = true
            }
            if frontCards[indexPath.row].link == "" {
                cardCell.urlIcon.isHidden = true
            }
            
            return cardCell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case groupCollectionView:
            selectedRow = indexPath.row
            groupId = serverGroups?.groups[indexPath.row].groupID
            offset = 0
            frontCards?.removeAll()
            
            DispatchQueue.main.async {
                self.setActivityIndicator()
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.cardListInGroupWithAPI(cardListInGroupRequest:
                                        CardListInGroupRequest(userId: UserDefaults.standard.string(forKey: Const.UserDefaultsKey.userID) ?? "",
                                                               groupId: self.serverGroups?.groups[indexPath.row].groupID ?? 0,
                                                               offset: 0)) {
                    self.isInfiniteScroll = true
                }
            }
        case cardsCollectionView:
            cardDetailFetchWithAPI(cardUUID: frontCards?[indexPath.row].cardID ?? "")
        default:
            return
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension GroupViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var width: CGFloat
        var height: CGFloat
        
        switch collectionView {
        case groupCollectionView:
            guard let cell = groupCollectionView.dequeueReusableCell(withReuseIdentifier: Const.Xib.groupCollectionViewCell, for: indexPath) as? GroupCollectionViewCell else {
                return .zero
            }
            cell.groupName.text = serverGroups?.groups[indexPath.row].groupName
            cell.groupName.sizeToFit()
            width = cell.groupName.frame.width + 30
            height = collectionView.frame.size.height
        case cardsCollectionView:
            width = collectionView.frame.size.width/2 - collectionView.frame.size.width * 8/327
            height = collectionView.frame.size.height * 258/558
        default:
            width = 0
            height = 0
        }
        return CGSize(width: width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch collectionView {
        case groupCollectionView:
            return .init(top: 0, left: 0, bottom: 0, right: 10)
        case cardsCollectionView:
            return .init(top: 0, left: 0, bottom: 28, right: 0)
        default:
            return .zero
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        switch collectionView {
        case groupCollectionView:
            return 5
        case cardsCollectionView:
            return collectionView.frame.size.width * 15/327
        default:
            return 0
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch collectionView {
        case groupCollectionView:
            return 5
        case cardsCollectionView:
            return collectionView.frame.size.width * 15/327
        default:
            return 0
        }
    }
}
