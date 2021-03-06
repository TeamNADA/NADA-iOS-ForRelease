//
//  GroupEditViewController.swift
//  NADA-iOS-forRelease
//
//  Created by 민 on 2021/11/21.
//

import UIKit

class GroupEditViewController: UIViewController {
    
    // MARK: - Properties
    var serverGroups: Groups?
    var unClass: Int?
    
    // MARK: - @IBOutlet Properties
    @IBOutlet weak var groupEditTableView: UITableView!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        groupEditTableView.register(GroupEditTableViewCell.nib(), forCellReuseIdentifier: Const.Xib.groupEditTableViewCell)
        groupEditTableView.register(EmptyGroupEditTableViewCell.nib(), forCellReuseIdentifier: Const.Xib.EmptyGroupEditTableViewCell)
        
        groupEditTableView.delegate = self
        groupEditTableView.dataSource = self
        serverGroupList()
    }
    
    // MARK: - @IBAction Properties
    @IBAction func dismissToPreviousView(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func presentToAddGroupBottom(_ sender: UIButton) {
        if serverGroups?.groups.count == 4 {
            makeOKAlert(title: "", message: "새로운 그룹은 최대 4개까지만 등록 가능합니다.")
        } else {
            let nextVC = AddGroupBottomSheetViewController()
                .setTitle("그룹 추가")
                .setHeight(184)
            nextVC.returnToGroupEditViewController = {
                self.makeOKAlert(title: "", message: "그룹이 추가되었습니다.", okAction: {_ in
                    self.groupListFetchWithAPI(userID: UserDefaults.standard.string(forKey: Const.UserDefaultsKey.userID) ?? "")
                }, completion: nil)
            }
            nextVC.modalPresentationStyle = .overFullScreen
            self.present(nextVC, animated: false, completion: nil)
        }
    }
    
}

// MARK: - TableView Delegate
extension GroupEditViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if serverGroups?.groups.isEmpty == true {
            return 674
        } else {
            return 59
        }
    }
    
    // Swipe Action
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if serverGroups?.groups.isEmpty == true {
            return nil
        } else {
            let deleteAction = UIContextualAction(style: .normal, title: "삭제", handler: { (_ action, _ view, _ success) in
                self.makeCancelDeleteAlert(title: "그룹 삭제", message: "해당 그룹에 있던 명함은\n미분류 그룹으로 이동합니다.", cancelAction: { _ in
                    // 취소 눌렀을 때 액션이 들어갈 부분
                }, deleteAction: { _ in
                    self.groupDeleteWithAPI(
                        groupID: self.serverGroups?.groups[indexPath.row].groupID ?? 0,
                        defaultGroupId: self.unClass ?? 0)
                    self.groupEditTableView.reloadData()
                    NotificationCenter.default.post(name: Notification.Name.passDataToGroup, object: 0, userInfo: nil)
                })
            })
            deleteAction.backgroundColor = .red
            
            let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])
            swipeActions.performsFirstActionWithFullSwipe = false
            
            return swipeActions
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if serverGroups?.groups.isEmpty == false {
            let nextVC = GroupNameEditBottomSheetViewController()
                .setTitle("그룹명 변경")
                .setHeight(184)
            nextVC.modalPresentationStyle = .overFullScreen
            nextVC.text = serverGroups?.groups[indexPath.row].groupName ?? ""
            nextVC.returnToGroupEditViewController = {
                self.groupListFetchWithAPI(userID: UserDefaults.standard.string(forKey: Const.UserDefaultsKey.userID) ?? "")
            }
            nextVC.nowGroup = serverGroups?.groups[indexPath.row]
            self.present(nextVC, animated: false, completion: nil)
        }
    }
}

// MARK: - TableView DataSource
extension GroupEditViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = serverGroups?.groups.count
        if count == 0 {
            return 1
        } else {
            return count ?? 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if serverGroups?.groups.isEmpty == true {
            guard let serviceCell = tableView.dequeueReusableCell(withIdentifier: Const.Xib.EmptyGroupEditTableViewCell, for: indexPath) as? EmptyGroupEditTableViewCell else { return UITableViewCell() }
            return serviceCell
        } else {
            guard let serviceCell = tableView.dequeueReusableCell(withIdentifier: Const.Xib.groupEditTableViewCell, for: indexPath) as? GroupEditTableViewCell else { return UITableViewCell() }
            
            serviceCell.initData(title: serverGroups?.groups[indexPath.row].groupName ?? "")
            return serviceCell
        }
    }
}

// MARK: - Extensions
extension GroupEditViewController {
    func serverGroupList() {
        self.unClass = serverGroups?.groups[0].groupID
        serverGroups?.groups.remove(at: 0)
    }
}

// MARK: - Network
extension GroupEditViewController {
    func groupListFetchWithAPI(userID: String) {
        GroupAPI.shared.groupListFetch(userID: userID) { response in
            switch response {
            case .success(let data):
                if let group = data as? Groups {
                    self.serverGroups = group
                    self.unClass = self.serverGroups?.groups[0].groupID
                    self.serverGroups?.groups.remove(at: 0)
                    self.groupEditTableView.reloadData()
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
    
    func groupDeleteWithAPI(groupID: Int, defaultGroupId: Int) {
        GroupAPI.shared.groupDelete(groupID: groupID, defaultGroupId: defaultGroupId) { response in
            switch response {
            case .success:
                print("groupDeleteWithAPI - success")
                self.groupListFetchWithAPI(userID: UserDefaults.standard.string(forKey: Const.UserDefaultsKey.userID) ?? "")
                self.groupEditTableView.reloadData()
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
    
}
