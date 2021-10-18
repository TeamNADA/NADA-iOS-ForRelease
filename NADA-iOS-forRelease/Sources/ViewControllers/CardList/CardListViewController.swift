//
//  CardListViewController.swift
//  NADA-iOS-forRelease
//
//  Created by 민 on 2021/09/27.
//

import UIKit
import Moya
import KakaoSDKCommon

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
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressCalled(_:)))
        cardListTableView.addGestureRecognizer(longPressGesture)
        
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
    
    func snapShotOfCall(_ inputView: UIView) -> UIView {
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0.0)
        inputView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()! as UIImage
        
        let cellSnapshot: UIView = UIImageView(image: image)
        cellSnapshot.layer.masksToBounds = false
        cellSnapshot.layer.cornerRadius = 0.0
        cellSnapshot.layer.shadowOffset = CGSize(width: -5.0, height: 0.0)
        cellSnapshot.layer.shadowRadius = 5.0
        cellSnapshot.layer.shadowOpacity = 0.4
        
        return cellSnapshot
    }
    
    @objc func longPressCalled(_ longPress: UILongPressGestureRecognizer) {
        let locationInView = longPress.location(in: cardListTableView)
        let indexPath = cardListTableView.indexPathForRow(at: locationInView)
        
        struct MyCell {
            static var cellSnapShot: UIView?
        }
        
        struct Path {
            static var initialIndexPath: IndexPath?
        }
        
        switch longPress.state {
            
        case UIGestureRecognizer.State.began:
            guard let indexPath = indexPath else {
                return
            }
            guard let cell = cardListTableView.cellForRow(at: indexPath) else { return }
            Path.initialIndexPath = indexPath
            MyCell.cellSnapShot = snapShotOfCall(cell)
            
            var center = cell.center
            MyCell.cellSnapShot?.center = center
            MyCell.cellSnapShot?.alpha = 0.0
            cardListTableView.addSubview(MyCell.cellSnapShot!)
            
            UIImageView.animate(withDuration: 0.25, animations: { () -> Void in
                center.y = locationInView.y
                MyCell.cellSnapShot?.center = center
                MyCell.cellSnapShot?.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                MyCell.cellSnapShot?.alpha = 0.98
                cell.alpha = 0.0
            }, completion: { (finished) -> Void in
                if finished {
                    cell.isHidden = true
                }
            })
            
        case UIGestureRecognizer.State.changed:
            var center = MyCell.cellSnapShot?.center
            center?.y = locationInView.y
            MyCell.cellSnapShot?.center = center!
            
            if (indexPath != nil) && (indexPath != Path.initialIndexPath) {
                swap(&cardItems[indexPath!.row], &cardItems[Path.initialIndexPath!.row])
                cardListTableView.moveRow(at: Path.initialIndexPath!, to: indexPath!)
                Path.initialIndexPath = indexPath
            }
        default:
            guard let cell = cardListTableView.cellForRow(at: Path.initialIndexPath!) else {return}
            cell.isHidden = true
            cell.alpha = 0.0
            
            UIView.animate(withDuration: 0.25, animations: { () -> Void in
                MyCell.cellSnapShot?.center = cell.center
                MyCell.cellSnapShot?.transform = CGAffineTransform.identity
                MyCell.cellSnapShot?.alpha = 0.0
            }, completion: { (finished) -> Void in
                if finished {
                    Path.initialIndexPath = nil
                    MyCell.cellSnapShot?.removeFromSuperview()
                    MyCell.cellSnapShot = nil
                }
            })
        }
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
