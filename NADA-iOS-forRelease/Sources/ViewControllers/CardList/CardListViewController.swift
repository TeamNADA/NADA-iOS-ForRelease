//
//  CardListViewController.swift
//  NADA-iOS-forRelease
//
//  Created by 민 on 2021/09/27.
//

import UIKit
import Moya

class CardListViewController: UIViewController {
    
    // MARK: - Properties
    var cardItems: [CardListDataModel] = []
    
    // MARK: - IBOutlet Properties
    @IBOutlet weak var cardListTableView: UITableView!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBackSwipeMotion()
        
        setCardList()
        
        cardListTableView.register(CardListTableViewCell.nib(), forCellReuseIdentifier: "CardListTableViewCell")
        
        cardListTableView.delegate = self
        cardListTableView.dataSource = self
        
    }
    
    // MARK: - IBAction Properties
    @IBAction func dismissToPreviousView(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Functions
    func setCardList() {
        cardItems.append(contentsOf: [
            CardListDataModel(title: "SOPT 28기 명함", date: "2021/08/29"),
            CardListDataModel(title: "SOPT 28기 명함", date: "2021/08/29"),
            CardListDataModel(title: "SOPT 28기 명함", date: "2021/08/29"),
            CardListDataModel(title: "SOPT 28기 명함", date: "2021/08/29"),
            CardListDataModel(title: "SOPT 28기 명함", date: "2021/08/29"),
            CardListDataModel(title: "SOPT 28기 명함", date: "2021/08/29"),
            CardListDataModel(title: "SOPT 28기 명함", date: "2021/08/29")
        ])
    }
    
    func navigationBackSwipeMotion() {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
}

// MARK: - UITableViewDelegate
extension CardListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76   
    }
    
    // Swipe Action
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "삭제", handler: { (_ action, _ view, _ success) in
            self.makeAlert(title: "명함 삭제", message: "명함을 정말 삭제하시겠습니까?", cancelAction: { _ in
                // 취소 눌렀을 때 액션이 들어갈 부분
            }, deleteAction: { _ in
                // 삭제 눌렀을 때 액션이 들어갈 부분
            }, completion: nil)
        })
        deleteAction.backgroundColor = .red
        
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])
        swipeActions.performsFirstActionWithFullSwipe = false
        
        return swipeActions
    }
}

// MARK: - UITableViewDataSource
extension CardListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cardItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let serviceCell = tableView.dequeueReusableCell(withIdentifier: Const.Xib.cardListTableViewCell, for: indexPath) as? CardListTableViewCell else { return UITableViewCell() }
        
        serviceCell.initData(title: cardItems[indexPath.row].title,
                             date: cardItems[indexPath.row].date)
        
        return serviceCell
    }
}
