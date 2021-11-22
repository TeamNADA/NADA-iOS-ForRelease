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
    @IBOutlet weak var addWithIDButton: UIButton!
    @IBOutlet weak var addWithQRButton: UIButton!
    
    // 중간 그룹 이름들 나열된 뷰
    @IBOutlet weak var editGroupButton: UIButton!
    // collectionview
    @IBOutlet weak var groupCollectionView: UICollectionView!
    @IBOutlet weak var cardsCollectionView: UICollectionView!
    
    // 그룹 이름들을 담을 변수 생성
    var groups = ["미분류", "SOPT", "그룹명엄청길어요이거", "인하대학교"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
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
         
        groupCollectionView.register(GroupCollectionViewCell.nib(), forCellWithReuseIdentifier: Const.Xib.GroupCollectionViewCell)
        cardsCollectionView.register(FrontCardCell.nib(), forCellWithReuseIdentifier: Const.Xib.frontCardCell)
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
        if collectionView == groupCollectionView {
            return groups.count
        } else {
            return 4
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == groupCollectionView {
            guard let groupCell = collectionView.dequeueReusableCell(withReuseIdentifier: Const.Xib.GroupCollectionViewCell, for: indexPath) as? GroupCollectionViewCell else {
                return UICollectionViewCell()
            }
            groupCell.groupName.text = groups[indexPath.row]
            
            if indexPath.row == 0 {
                groupCell.isSelected = true
            } else {
                groupCell.isSelected = false
            }
            groupCollectionView.layoutIfNeeded()
            return groupCell
        } else {
            guard let cardCell = collectionView.dequeueReusableCell(withReuseIdentifier: Const.Xib.frontCardCell, for: indexPath) as? FrontCardCell else {
                return UICollectionViewCell()
            }
            
            cardCell.backgroundColor = .blue
            cardCell.cornerRadius = 15
            return cardCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension GroupViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat
        var width: CGFloat
        
        if collectionView == groupCollectionView {
            if groups[indexPath.row].count > 4 {
                width = CGFloat(groups[indexPath.row].count) * 16
            } else {
                width = 62
            }
            height = collectionView.frame.size.height
        } else {
            width = collectionView.frame.size.width / 2 - 7.5
            height = collectionView.frame.size.height / 2
        }

        return CGSize(width: width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == groupCollectionView {
            return 5
        } else {
            return 14
        }
    }
}
