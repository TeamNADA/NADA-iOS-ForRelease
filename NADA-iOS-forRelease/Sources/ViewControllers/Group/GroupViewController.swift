//
//  GroupViewController.swift
//  NADA-iOS-forRelease
//
//  Created by 민 on 2021/10/08.
//

import Photos
import UIKit

import FirebaseAnalytics
import Kingfisher
import NVActivityIndicatorView
import RxSwift
import RxRelay
import RxCocoa
import RxGesture
import SnapKit
import Then

class GroupViewController: UIViewController {
    
    // MARK: - Properties
    
    private var moduleFactory = ModuleFactory.shared
    private let disposeBag = DisposeBag()
    
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
        Analytics.logEvent(Tracking.Event.touchEditGroup, parameters: nil)
        let groupEditVC = self.moduleFactory.makeGroupEditVC(groupList: serverGroups ?? [])
        navigationController?.pushViewController(groupEditVC, animated: true)
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
    var serverGroups: [String]? = []
    var frontCards: [Card]? = []
    var serverCardsWithBack: Card?
    var groupName: String = "미분류"
    
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
            self.groupListFetchWithAPI()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setTracking()
    }
}

// MARK: - Extensions

extension GroupViewController {
    private func setTracking() {
        Analytics.logEvent(AnalyticsEventScreenView,
                           parameters: [
                            AnalyticsParameterScreenName: Tracking.Screen.cardGroupList
                           ])
    }
    
    private func registerCell() {
        groupCollectionView.delegate = self
        groupCollectionView.dataSource = self
        cardsCollectionView.delegate = self
        cardsCollectionView.dataSource = self
         
        groupCollectionView.register(GroupCollectionViewCell.nib(), forCellWithReuseIdentifier: Const.Xib.groupCollectionViewCell)
        cardsCollectionView.register(FrontCardCell.nib(), forCellWithReuseIdentifier: FrontCardCell.className)
        cardsCollectionView.register(FanFrontCardCell.nib(), forCellWithReuseIdentifier: FanFrontCardCell.className)
        cardsCollectionView.register(CompanyFrontCardCell.nib(), forCellWithReuseIdentifier: CompanyFrontCardCell.className)
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
        
        groupListFetchWithAPI()
    }
}

// MARK: - Network

extension GroupViewController {
    func groupListFetchWithAPI() {
        GroupAPI.shared.groupListFetch { response in
            switch response {
            case .success(let data):
                if let group = data as? [String] {
                    self.serverGroups = group
                    self.groupCollectionView.reloadData()
                    print("selectedRow: ", self.selectedRow)
                    self.cardListInGroupWithAPI(cardListInGroupRequest: CardListInGroupRequest(pageNo: 1, pageSize: 6, groupName: self.groupName)) {
                        if self.frontCards?.count != 0 {
                            self.cardsCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
                        }
                        self.isInfiniteScroll = true
                    }
                }
                print("groupListFetchWithAPI - success")
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
                // TODO: API 수정되면 밑에 리로드 지우기
                self.cardsCollectionView.reloadData()
                
                if let cards = data as? [Card] {
                    self.frontCards = cards
                    if self.frontCards?.count == 0 {
                        self.emptyView.isHidden = false
                    } else {
                        self.emptyView.isHidden = true
                    }
                    self.cardsCollectionView.reloadData()
                    print("✅")
                }
                // completion()
                print("cardListInGroupWithAPI - success")
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
                    nextVC.groupName = self.groupName
                    nextVC.serverGroups = self.serverGroups
//                    nextVC.cardType = card.cardType 
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
                    cardListInGroupWithAPI(cardListInGroupRequest: CardListInGroupRequest(pageNo: offset,
                                                                                          pageSize: 10,
                                                                                          groupName: serverGroups?[self.selectedRow] ?? "")) {
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
            return serverGroups?.count ?? 0
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
            groupCell.groupName.text = serverGroups?[indexPath.row]
            
            if indexPath.row == selectedRow {
                collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .init())
            }
            return groupCell
        case cardsCollectionView:
            guard let frontCards = frontCards else { return UICollectionViewCell() }
            switch frontCards[indexPath.row].cardType {
            case "BASIC":
                guard let cardCell = collectionView.dequeueReusableCell(withReuseIdentifier: FrontCardCell.className, for: indexPath) as? FrontCardCell else {
                    return UICollectionViewCell()
                }
                cardCell.initCellFromServer(cardData: frontCards[indexPath.row], isShareable: false)
                cardCell.setConstraints()
                cardCell.setCornerRadius(15)
                
                return cardCell
            case "FAN":
                guard let cardCell = collectionView.dequeueReusableCell(withReuseIdentifier: FanFrontCardCell.className, for: indexPath) as? FanFrontCardCell else {
                    return UICollectionViewCell()
                }
                cardCell.initCellFromServer(cardData: frontCards[indexPath.row], isShareable: false)
                cardCell.setConstraints()
                cardCell.setCornerRadius(15)
                
                return cardCell
            case "COMPANY":
                guard let cardCell = collectionView.dequeueReusableCell(withReuseIdentifier: CompanyFrontCardCell.className, for: indexPath) as? CompanyFrontCardCell else {
                    return UICollectionViewCell()
                }
                cardCell.initCellFromServer(cardData: frontCards[indexPath.row], isShareable: false)
                cardCell.setConstraints()
                cardCell.setCornerRadius(15)
                
                return cardCell
            default:
                return UICollectionViewCell()
            }
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case groupCollectionView:
            selectedRow = indexPath.row
            self.groupName = serverGroups?[indexPath.row] ?? ""
            offset = 0
            frontCards?.removeAll()
            Analytics.logEvent(Tracking.Event.touchGroup + String(indexPath.row+1), parameters: nil)
            
            DispatchQueue.main.async {
                self.setActivityIndicator()
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.cardListInGroupWithAPI(cardListInGroupRequest:
                                                CardListInGroupRequest(pageNo: 1, pageSize: 10, groupName: self.groupName)) {
                    self.isInfiniteScroll = true
                }
            }
        case cardsCollectionView:
            Analytics.logEvent(Tracking.Event.touchGroupCard + String(indexPath.row+1), parameters: nil)
            cardDetailFetchWithAPI(cardUUID: frontCards?[indexPath.row].cardUUID ?? "")
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
            cell.groupName.text = serverGroups?[indexPath.row]
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
