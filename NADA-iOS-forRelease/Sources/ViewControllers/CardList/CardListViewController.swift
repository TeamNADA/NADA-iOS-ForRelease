//
//  CardListViewController.swift
//  NADA-iOS-forRelease
//
//  Created by 민 on 2021/09/27.
//

import UIKit
import Moya

class CardListViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var cardListTableView: UITableView!
    
    // MARK: - Properties
    var cardItems: [CardListDataModel] = []
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCardList()
        
        cardListTableView.register(CardListTableViewCell.nib(), forCellReuseIdentifier: "CardListTableViewCell")
        cardListTableView.delegate = self
        cardListTableView.dataSource = self
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
}

// MARK: - Extensions
// TableViewDelegate
extension CardListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    // Swipe Action
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "삭제", handler: { (action, view, success) in
        })
        
        deleteAction.backgroundColor = .red
        
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])
        swipeActions.performsFirstActionWithFullSwipe = false
        
        return swipeActions
    }
}

// TableViewDataSource
extension CardListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cardItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let serviceCell = tableView.dequeueReusableCell(withIdentifier: CardListTableViewCell.identifier, for: indexPath) as? CardListTableViewCell else { return UITableViewCell() }
        
        serviceCell.setData(title: cardItems[indexPath.row].title,
                            date: cardItems[indexPath.row].date)
        
        return serviceCell
    }
}

// 명함 삭제시 Alert창 구현
extension CardListViewController {
    func makeRequestAlert(title: String,
                          message: String,
                          cancelAction: ((UIAlertAction) -> Void)? = nil,
                          deleteAction: ((UIAlertAction) -> Void)?,
                          completion: (() -> Void)? = nil) {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: cancelAction)
        alertViewController.addAction(cancelAction)
        
        let deleteAction = UIAlertAction(title: "삭제", style: .default, handler: deleteAction)
        alertViewController.addAction(deleteAction)
        
        alertViewController.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 75)
        
        self.present(alertViewController, animated: true, completion: completion)
    }
}
