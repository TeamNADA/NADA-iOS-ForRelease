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
        
        //그룹 리스트 조회 서버 테스트
        getGroupListFetchWithAPI(userID: "nada")
        //그룹 삭제 서버 테스트
        deleteGroupWithAPI(groupID: 1)
    }
    
}

// MARK: - Network

extension GroupViewController {
    func getGroupListFetchWithAPI(userID: String) {
        GroupAPI.shared.getGroupListFetch(userID: userID) { response in
            switch response {
            case .success(let data):
                if let group = data as? Groups {
                    print(group)
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
                    print(group)
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
}
