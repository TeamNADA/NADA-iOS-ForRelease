//
//  GroupViewController.swift
//  NADA-iOS-forRelease
//
//  Created by 민 on 2021/10/08.
//

import UIKit

class GroupViewController: UIViewController {
    
    // MARK: - Properties
    // 네비게이션 바
    @IBAction func presentToAddWithIdView(_ sender: Any) {
        let nextVC = AddWithIdBottomSheetViewController().setTitle("ID로 명함 추가").setHeight(184)
        nextVC.modalPresentationStyle = .overFullScreen
        self.present(nextVC, animated: true, completion: nil)
    }
    
    @IBAction func presentToAddWithQrView(_ sender: Any) {
        guard let nextVC = UIStoryboard.init(name: Const.Storyboard.Name.qrScan, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.qrScanViewController) as? QRScanViewController else { return }
        nextVC.modalPresentationStyle = .overFullScreen
        self.present(nextVC, animated: true, completion: nil)
    }
    
    // 중간 그룹 이름들 나열된 뷰
    @IBAction func pushToGroupEdit(_ sender: Any) {
        guard let nextVC = UIStoryboard.init(name: Const.Storyboard.Name.groupEdit, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.groupEditViewController) as? GroupEditViewController else { return }
        
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    // collectionview
    @IBOutlet weak var groupCollectionView: UICollectionView!
    @IBOutlet weak var cardsCollectionView: UICollectionView!
    
    // 그룹 이름들을 담을 변수 생성
    var groups = ["미분류", "SOPT", "그룹명엄청길어요이거", "인하대학교"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        setUI()
        // 그룹 리스트 조회 서버 테스트
//        groupListFetchWithAPI(userID: "nada")
//         그룹 삭제 서버 테스트
//        groupDeleteWithAPI(groupID: 1)
//         그룹 추가 서버 테스트
//        groupAddWithAPI(groupRequest: GroupAddRequest(userId: "nada", groupName: "나다나다"))
//         그룹 수정 서버 테스트
//        groupEditWithAPI(groupRequest: GroupEditRequest(groupId: 5, groupName: "수정나다"))
//         그룹 속 명함 추가 테스트
//        cardAddInGroupWithAPI(cardRequest: CardAddInGroupRequest(cardId: "cardA", userId: "nada", groupId: 1))
//         그룹 속 명함 조회 테스트
//        cardListInGroupWithAPI(cardListInGroupRequest: CardListInGroupRequest(userId: "nada2", groupId: 3, offset: 0))
//         명함 검색 테스트
//        cardDetailFetchWithAPI(cardID: "cardA")
        
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
        navigationController?.navigationBar.isHidden = true
    }
}

// MARK: - Network

extension GroupViewController {
    func groupListFetchWithAPI(userID: String) {
        GroupAPI.shared.groupListFetch(userID: userID) { response in
            switch response {
            case .success(let data):
                if let group = data as? Groups {
//                    print(group)
                    // 그룹 리스트 조회 서버통신 성공했을때
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
    
    func groupDeleteWithAPI(groupID: Int) {
        GroupAPI.shared.groupDelete(groupID: groupID) { response in
            switch response {
            case .success(let data):
                if let group = data as? Groups {
//                    print(group)
                    // 그룹 삭제 서버 통신 성공했을 떄
                }
            case .requestErr(let message):
                print("groupDeleteWithAPI - requestErr: \(message)")
            case .pathErr:
                print("groupDeleteWithAPI - pathErr")
            case .serverErr:
                print("groupDeleteWithAPI - serverErr")
            case .networkFail:
                print("groupDeleteWithAPI - networkFail")
            }
        }
    }
    
    func groupAddWithAPI(groupRequest: GroupAddRequest) {
        GroupAPI.shared.groupAdd(groupRequest: groupRequest) { response in
            switch response {
            case .success(let data):
                if let group = data as? Groups {
//                    print(group)
                    // 그룹 추가 서버 통신 성공했을 떄
                }
            case .requestErr(let message):
                print("groupAddWithAPI - requestErr: \(message)")
            case .pathErr:
                print("groupAddWithAPI - pathErr")
            case .serverErr:
                print("groupAddWithAPI - serverErr")
            case .networkFail:
                print("groupAddWithAPI - networkFail")
            }
        }
    }
    
    func groupEditWithAPI(groupRequest: GroupEditRequest) {
        GroupAPI.shared.groupEdit(groupRequest: groupRequest) { response in
            switch response {
            case .success(let data):
                if let group = data as? Groups {
//                    print(group)
                    // 그룹 추가 서버 통신 성공했을 떄
                }
            case .requestErr(let message):
                print("groupEditWithAPI - requestErr: \(message)")
            case .pathErr:
                print("groupEditWithAPI - pathErr")
            case .serverErr:
                print("groupEditWithAPI - serverErr")
            case .networkFail:
                print("groupEditWithAPI - networkFail")
            }
        }
    }
    
    func cardAddInGroupWithAPI(cardRequest: CardAddInGroupRequest) {
        GroupAPI.shared.cardAddInGroup(cardRequest: cardRequest) { response in
            switch response {
            case .success(let data):
                if let group = data as? Groups {
//                    print(group)
                    // 그룹 추가 서버 통신 성공했을 떄
                }
            case .requestErr(let message):
                print("cardAddInGroupWithAPI - requestErr: \(message)")
            case .pathErr:
                print("cardAddInGroupWithAPI - pathErr")
            case .serverErr:
                print("cardAddInGroupWithAPI - serverErr")
            case .networkFail:
                print("cardAddInGroupWithAPI - networkFail")
            }
        }
    }
    
    func cardListInGroupWithAPI(cardListInGroupRequest: CardListInGroupRequest) {
        GroupAPI.shared.cardListFetchInGroup(cardListInGroupRequest: cardListInGroupRequest) { response in
            switch response {
            case .success(let data):
                if let cards = data as? CardsInGroupResponse {
//                    print(group)
                    // 그룹 추가 서버 통신 성공했을 떄
                    print(cards)
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
                if let card = data as? Card {
//                    print(card)
                    // 통신 성공
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
            return groups.count
        case cardsCollectionView:
            return 5
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
            
            groupCell.groupName.text = groups[indexPath.row]
            if indexPath.row == 0 {
                collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .init())
            }
            return groupCell
        case cardsCollectionView:
            guard let cardCell = collectionView.dequeueReusableCell(withReuseIdentifier: Const.Xib.cardInGroupCollectionViewCell, for: indexPath) as? CardInGroupCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            return cardCell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case groupCollectionView:
            print(indexPath.row)
        case cardsCollectionView:
            print(indexPath.row)
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
            if groups[indexPath.row].count > 4 {
                width = CGFloat(groups[indexPath.row].count) * 16
            } else {
                width = 62
            }
            height = collectionView.frame.size.height
        case cardsCollectionView:
            width = 156
            height = 258
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
        default:
            return .zero
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        switch collectionView {
        case groupCollectionView:
            return 5
        default:
            return 0
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch collectionView {
        case cardsCollectionView:
            return 14
        default:
            return 0
        }
    }
}
