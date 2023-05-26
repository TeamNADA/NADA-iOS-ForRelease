//
//  GroupEditViewController.swift
//  NADA-iOS-forRelease
//
//  Created by 민 on 2021/11/21.
//

import UIKit

import FirebaseAnalytics
import RxSwift
import RxRelay
import RxCocoa
import RxGesture
import SnapKit
import Then

class GroupEditViewController: UIViewController {
    
    // MARK: - Properties
    var viewModel: GroupEditViewModel!
    private let disposeBag = DisposeBag()
    var serverGroups: [String]?
    var unClass: String?
    
    // MARK: - @IBOutlet Properties
    @IBOutlet weak var groupEditTableView: UITableView!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegate()
        setRegister()
        bindViewModels()
        serverGroupList()
        setTracking()
    }
    
    // MARK: - @IBAction Properties
    @IBAction func dismissToPreviousView(_ sender: UIButton) {
        Analytics.logEvent(Tracking.Event.touchEditGroupBack, parameters: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func presentToAddGroupBottom(_ sender: UIButton) {
        Analytics.logEvent(Tracking.Event.touchEditGroupAdd, parameters: nil)
        if serverGroups?.count == 4 {
            makeOKAlert(title: "", message: "새로운 그룹은 최대 4개까지만 등록 가능합니다.")
        } else {
            let nextVC = AddGroupBottomSheetViewController()
                .setTitle("그룹 추가")
                .setHeight(184)
            nextVC.returnToGroupEditViewController = {
                self.makeOKAlert(title: "", message: "그룹이 추가되었습니다.", okAction: {_ in
                    self.groupListFetchWithAPI()
                }, completion: nil)
            }
            nextVC.modalPresentationStyle = .overFullScreen
            self.present(nextVC, animated: false, completion: nil)
        }
    }
    
    private func bindViewModels() {
        let input = GroupEditViewModel.Input(
            viewWillAppearEvent: self.rx.methodInvoked(#selector(UIViewController.viewWillAppear(_:))).map { _ in })
        let output = self.viewModel.transform(input: input)
        
        output.groupListRelay
            .compactMap { $0 }
            .withUnretained(self)
            .subscribe { owner, list in
                owner.setData(groupList: list)
                self.unClass = self.serverGroups?[0]
                self.serverGroups?.remove(at: 0)
            }.disposed(by: self.disposeBag)
    }
    
    func setData(groupList: [String]) {
        self.serverGroups = groupList
        self.groupEditTableView.reloadData()
    }
    
    private func setDelegate() {
        groupEditTableView.delegate = self
        groupEditTableView.dataSource = self
    }
    
    private func setRegister() {
        groupEditTableView.register(GroupEditTableViewCell.nib(), forCellReuseIdentifier: GroupEditTableViewCell.className)
        groupEditTableView.register(EmptyGroupEditTableViewCell.nib(), forCellReuseIdentifier: EmptyGroupEditTableViewCell.className)
    }
    
    private func setTracking() {
        Analytics.logEvent(AnalyticsEventScreenView,
                           parameters: [
                            AnalyticsParameterScreenName: Tracking.Screen.editGroupList
                           ])
    }
}

// MARK: - TableView Delegate
extension GroupEditViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if serverGroups?.isEmpty == true {
            return 674
        } else {
            return 59
        }
    }
    
    // Swipe Action
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if serverGroups?.isEmpty == true {
            return nil
        } else {
            let deleteAction = UIContextualAction(style: .normal, title: "삭제", handler: { (_ action, _ view, _ success) in
                self.makeCancelDeleteAlert(title: "그룹 삭제", message: "해당 그룹에 있던 명함은\n미분류 그룹으로 이동합니다.", cancelAction: { _ in
                    // 취소 눌렀을 때 액션이 들어갈 부분
                }, deleteAction: { _ in
                    self.groupDeleteWithAPI(cardGroupName: self.serverGroups?[indexPath.row] ?? "")
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
        if serverGroups?.isEmpty == false {
            Analytics.logEvent(Tracking.Event.touchEditGroupNumber + String(indexPath.row + 1), parameters: nil)
            let nextVC = GroupNameEditBottomSheetViewController()
                .setTitle("그룹명 변경")
                .setHeight(184)
            nextVC.modalPresentationStyle = .overFullScreen
            nextVC.text = serverGroups?[indexPath.row] ?? ""
            nextVC.returnToGroupEditViewController = {
                self.groupListFetchWithAPI()
            }
            nextVC.nowGroup = serverGroups?[indexPath.row]
            self.present(nextVC, animated: false, completion: nil)
        }
    }
}

// MARK: - TableView DataSource
extension GroupEditViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = serverGroups?.count
        if count == 0 {
            return 1
        } else {
            return count ?? 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if serverGroups?.isEmpty == true {
            guard let serviceCell = tableView.dequeueReusableCell(withIdentifier: EmptyGroupEditTableViewCell.className, for: indexPath) as? EmptyGroupEditTableViewCell else { return UITableViewCell() }
            return serviceCell
        } else {
            guard let serviceCell = tableView.dequeueReusableCell(withIdentifier: GroupEditTableViewCell.className, for: indexPath) as? GroupEditTableViewCell else { return UITableViewCell() }
            
            serviceCell.initData(title: serverGroups?[indexPath.row] ?? "")
            return serviceCell
        }
    }
}

// MARK: - Extensions
extension GroupEditViewController {
    func serverGroupList() {
        self.unClass = serverGroups?[0]
        serverGroups?.remove(at: 0)
    }
}

// MARK: - Network
extension GroupEditViewController {
    func groupListFetchWithAPI() {
        GroupAPI.shared.groupListFetch { response in
            switch response {
            case .success(let data):
                if let group = data as? [String] {
                    self.serverGroups = group
                    self.unClass = self.serverGroups?[0]
                    self.serverGroups?.remove(at: 0)
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
    
    func groupDeleteWithAPI(cardGroupName: String) {
        GroupAPI.shared.groupDelete(cardGroupName: cardGroupName) { response in
            switch response {
            case .success:
                print("groupDeleteWithAPI - success")
                self.groupListFetchWithAPI()
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
