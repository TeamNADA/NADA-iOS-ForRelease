//
//  GroupEditViewController.swift
//  NADA-iOS-forRelease
//
//  Created by 민 on 2021/11/21.
//

import UIKit

class GroupEditViewController: UIViewController {

    // MARK: - Properties
    var cardItems = ["SOPT", "동아리", "학교", "NADA NADA NADA NADA NADA"]
    
    // MARK: - @IBOutlet Properties
    @IBOutlet weak var groupEditTableView: UITableView!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        groupEditTableView.register(GroupEditTableViewCell.nib(), forCellReuseIdentifier: Const.Xib.groupEditTableViewCell)
        
        groupEditTableView.delegate = self
        groupEditTableView.dataSource = self
    }
    
    // MARK: - @IBAction Properties
    @IBAction func dismissToPreviousView(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func presentToAddGroupBottom(_ sender: UIButton) {
        let nextVC = AddGroupBottomSheetViewController().setTitle("그룹 추가").setHeight(184)
        nextVC.modalPresentationStyle = .overFullScreen
        self.present(nextVC, animated: true, completion: nil)
    }
}

// MARK: - TableView Delegate
extension GroupEditViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 59
    }
    
    // Swipe Action
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "삭제", handler: { (_ action, _ view, _ success) in
            self.makeAlert(title: "그룹 삭제", message: "해당 그룹에 있던 명함은\n미분류 그룹으로 이동합니다.", cancelAction: { _ in
                // 취소 눌렀을 때 액션이 들어갈 부분
            }, deleteAction: { _ in
                // 
            }, completion: nil)
        })
        deleteAction.backgroundColor = .red
        
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])
        swipeActions.performsFirstActionWithFullSwipe = false
        
        return swipeActions
    }
}

// MARK: - TableView DataSource
extension GroupEditViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cardItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let serviceCell = tableView.dequeueReusableCell(withIdentifier: Const.Xib.groupEditTableViewCell, for: indexPath) as? GroupEditTableViewCell else { return UITableViewCell() }
        
        serviceCell.initData(title: cardItems[indexPath.row])
        
        return serviceCell
    }
}
