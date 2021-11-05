//
//  GroupViewController.swift
//  NADA-iOS-forRelease
//
//  Created by 민 on 2021/10/08.
//

import UIKit

class GroupViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 그룹 리스트 조회 서버 테스트
        getGroupListFetchWithAPI(userID: "nada")
        // 그룹 삭제 서버 테스트
        deleteGroupWithAPI(groupID: 1)
        // 그룹 추가 서버 테스트
        postGroupAddWithAPI(groupRequest: GroupAddRequest(userId: "nada", groupName: "나다나다"))
    }
    
}

// MARK: - Network

extension GroupViewController {
    func getGroupListFetchWithAPI(userID: String) {
        GroupAPI.shared.getGroupListFetch(userID: userID) { response in
            switch response {
            case .success(let data):
                if let group = data as? Groups {
//                    print(group)
                    // 그룹 리스트 조회 서버통신 성공했을때
                }
            case .requestErr(let message):
                print("getGroupListFetchWithAPI - requestErr", message)
            case .pathErr:
                print("getGroupListFetchWithAPI - pathErr")
            case .serverErr:
                print("getGroupListFetchWithAPI - serverErr")
            case .networkFail:
                print("getGroupListFetchWithAPI - networkFail")
            }
        }
    }
    
    func deleteGroupWithAPI(groupID: Int) {
        GroupAPI.shared.deleteGroup(groupID: groupID) { response in  
            switch response {
            case .success(let data):
                if let group = data as? Groups {
//                    print(group)
                    // 그룹 삭제 서버 통신 성공했을 떄
                }
            case .requestErr(let message):
                print("deleteGroupWithAPI - requestErr", message)
            case .pathErr:
                print("deleteGroupWithAPI - pathErr")
            case .serverErr:
                print("deleteGroupWithAPI - serverErr")
            case .networkFail:
                print("deleteGroupWithAPI - networkFail")
            }
        }
    }
    
    func postGroupAddWithAPI(groupRequest: GroupAddRequest) {
        GroupAPI.shared.postGroupAdd(groupRequest: groupRequest) { response in
            switch response {
            case .success(let data):
                if let group = data as? Groups {
//                    print(group)
                    // 그룹 추가 서버 통신 성공했을 떄
                }
            case .requestErr(let message):
                print("postGroupAddWithAPI - requestErr", message)
            case .pathErr:
                print("postGroupAddWithAPI - pathErr")
            case .serverErr:
                print("postGroupAddWithAPI - serverErr")
            case .networkFail:
                print("postGroupAddWithAPI - networkFail")
            }
        }
    }
}
