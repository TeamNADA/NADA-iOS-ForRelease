//
//  GroupViewController.swift
//  NADA-iOS-forRelease
//
//  Created by 민 on 2021/10/08.
//

import Photos
import UIKit
import Kingfisher

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
    
    // collectionview
    @IBOutlet weak var groupCollectionView: UICollectionView!
    @IBOutlet weak var cardsCollectionView: UICollectionView!
    @IBOutlet weak var emptyView: UIView!
    
    // 그룹 이름들을 담을 변수 생성
    var serverGroups: Groups?
    var serverCards: CardsInGroupResponse?
    var serverCardsWithBack: Card?
    var groupId: Int?
    
    var selectedRow = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        setUI()

//         그룹 속 명함 조회 테스트
//        cardListInGroupWithAPI(cardListInGroupRequest: CardListInGroupRequest(userId: "nada", groupId: 5, offset: 0))
//         명함 검색 테스트
//        cardDetailFetchWithAPI(cardID: "cardA")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // 그룹 리스트 조회 서버 테스트
        NotificationCenter.default.addObserver(self, selector: #selector(didRecieveDataNotification(_:)), name: Notification.Name.passDataToGroup, object: nil)
        print("viewWillAppear")
        groupListFetchWithAPI(userID: UserDefaults.standard.string(forKey: Const.UserDefaults.userID) ?? "")

    }
    
}

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
    
    @objc func didRecieveDataNotification(_ notification: Notification) {
        selectedRow = notification.object as? Int ?? 0
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
                    if !group.groups.isEmpty {
                        self.cardListInGroupWithAPI(cardListInGroupRequest: CardListInGroupRequest(userId: UserDefaults.standard.string(forKey: Const.UserDefaults.userID) ?? "", groupId: group.groups[self.selectedRow].groupID, offset: 0))
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
    
    func cardListInGroupWithAPI(cardListInGroupRequest: CardListInGroupRequest) {
        GroupAPI.shared.cardListFetchInGroup(cardListInGroupRequest: cardListInGroupRequest) { response in
            switch response {
            case .success(let data):
                if let cards = data as? CardsInGroupResponse {
                    self.serverCards = cards
                    if cards.cards.count == 0 {
                        self.emptyView.isHidden = false
                    } else {
                        self.emptyView.isHidden = true
                    }
                    self.cardsCollectionView.reloadData()
                }
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
    
    func cardDetailFetchWithAPI(cardID: String) {
        CardAPI.shared.cardDetailFetch(cardID: cardID) { response in
            switch response {
            case .success(let data):
                if let card = data as? CardClass {
                    guard let nextVC = UIStoryboard.init(name: Const.Storyboard.Name.cardDetail, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.cardDetailViewController) as? CardDetailViewController else { return }
                    
                    nextVC.cardDataModel = Card(cardID: card.card.cardID,
                                                background: card.card.background,
                                                title: card.card.title,
                                                name: card.card.name,
                                                birthDate: card.card.birthDate,
                                                mbti: card.card.mbti,
                                                instagram: card.card.instagram,
                                                link: card.card.link,
                                                cardDescription: card.card.cardDescription,
                                                isMincho: card.card.isMincho,
                                                isSoju: card.card.isSoju,
                                                isBoomuk: card.card.isBoomuk,
                                                isSauced: card.card.isSauced,
                                                oneTmi: card.card.oneTmi,
                                                twoTmi: card.card.twoTmi,
                                                threeTmi: card.card.threeTmi)
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
    
}

// MARK: - UICollectionViewDataSource
extension GroupViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case groupCollectionView:
            return serverGroups?.groups.count ?? 0
        case cardsCollectionView:
            return serverCards?.cards.count ?? 0
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
            
            cardCell.backgroundImageView.updateServerImage(serverCards?.cards[indexPath.row].background ?? "")
            cardCell.cardId = serverCards?.cards[indexPath.row].cardID 
            cardCell.titleLabel.text = serverCards?.cards[indexPath.row].title
            cardCell.descriptionLabel.text = serverCards?.cards[indexPath.row].cardDescription
            cardCell.userNameLabel.text = serverCards?.cards[indexPath.row].name
            cardCell.birthLabel.text = serverCards?.cards[indexPath.row].birthDate
            cardCell.mbtiLabel.text = serverCards?.cards[indexPath.row].mbti
            cardCell.instagramIDLabel.text = serverCards?.cards[indexPath.row].instagram
            cardCell.lineURLLabel.text = serverCards?.cards[indexPath.row].link
            
            if serverCards?.cards[indexPath.row].instagram == "" {
                cardCell.instagramIcon.isHidden = true
            }
            if serverCards?.cards[indexPath.row].link == "" {
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
            cardListInGroupWithAPI(cardListInGroupRequest:
                                    CardListInGroupRequest(userId: UserDefaults.standard.string(forKey: Const.UserDefaults.userID) ?? "",
                                                           groupId: serverGroups?.groups[indexPath.row].groupID ?? 0,
                                                           offset: 0))
        case cardsCollectionView:
            cardDetailFetchWithAPI(cardID: serverCards?.cards[indexPath.row].cardID ?? "")
        default:
            print(indexPath.row)
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
            if serverGroups?.groups[indexPath.row].groupName.count ?? 0 > 4 {
                width = CGFloat(serverGroups?.groups[indexPath.row].groupName.count ?? 0) * 16
            } else {
                width = 62
            }
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
