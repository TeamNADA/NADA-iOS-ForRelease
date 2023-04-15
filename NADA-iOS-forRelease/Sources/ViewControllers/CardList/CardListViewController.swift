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
    var cardItems: [Card] = []
    var newCardItems: [CardReorderInfo] = []
    
    // MARK: - IBOutlet Properties
    @IBOutlet weak var cardListTableView: UITableView!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBackSwipeMotion()
        setLongPressGesture()
        
        cardListTableView.register(CardListTableViewCell.nib(), forCellReuseIdentifier: "CardListTableViewCell")
        cardListTableView.register(EmptyCardListTableViewCell.nib(), forCellReuseIdentifier: "EmptyCardListTableViewCell")
        
        cardListTableView.delegate = self
        cardListTableView.dataSource = self
        
        cardListFetchWithAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        cardListTableView.reloadData()
    }
    
    // MARK: - IBAction Properties
    @IBAction func dismissToPreviousView(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Functions
    func setLongPressGesture() {
        self.cardListTableView.allowsSelection = false
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressCalled(gestureRecognizer:)))
        cardListTableView.addGestureRecognizer(longPressGesture)
    }
    
    func navigationBackSwipeMotion() {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    func snapShotOfCall(_ inputView: UIView) -> UIView {
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0.0)
        inputView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        let cellSnapshot: UIView = UIImageView(image: image)
        cellSnapshot.layer.masksToBounds = false
        cellSnapshot.layer.cornerRadius = 0.0
        cellSnapshot.layer.shadowOffset = CGSize(width: -5.0, height: 0.0)
        cellSnapshot.layer.shadowRadius = 5.0
        cellSnapshot.layer.shadowOpacity = 0.4
        
        return cellSnapshot
    }
    
    @objc func pinButtonClicked(_ sender: UIButton) {
        let contentView = sender.superview
        guard let cell = contentView?.superview as? UITableViewCell else { return }
        let index = cardListTableView.indexPath(for: cell)
        
        if index!.row > 0 {
            self.cardItems.insert(self.cardItems.remove(at: index!.row), at: 0)
            cardListTableView.reloadData()
            cardListTableView.moveRow(at: index!, to: IndexPath(row: 0, section: 0))
            
            newCardItems = []
            
            for index in 0..<cardItems.count {
                newCardItems.append(CardReorderInfo(cardID: cardItems[index].cardID,
                                                    isRepresentative: index == 0 ? true : false,
                                                    sortOrder: index == 0 ? 0 : cardItems.count - index))
            }
            cardReorderWithAPI(request: newCardItems)
        }
    }
}

// MARK: - UITableViewDelegate
extension CardListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if cardItems.isEmpty {
            return 670
        } else {
            return 58
        }
    }
    
    // Swipe Action
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.row == 0 {
            return nil
        } else {
            let deleteAction = UIContextualAction(style: .normal, title: "삭제", handler: { (_ action, _ view, _ success) in
                self.makeCancelDeleteAlert(title: "명함 삭제", message: "명함을 정말 삭제하시겠습니까?\n공유된 명함일 경우, 친구의 명함 모음에서도 해당 명함이 삭제됩니다.", cancelAction: { _ in
                    // 취소 눌렀을 때 액션이 들어갈 부분
                }, deleteAction: { _ in
                    self.deleteCardWithAPI(cardID: self.cardItems[indexPath.row].cardID)
                    self.cardListTableView.reloadData()
                })
            })
            deleteAction.backgroundColor = .red
            
            let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])
            swipeActions.performsFirstActionWithFullSwipe = false
            
            return swipeActions
        }
    }
}

// MARK: - UITableViewDataSource
extension CardListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = cardItems.count
        if count == 0 {
            return 1
        } else {
            return count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if cardItems.isEmpty {
            guard let serviceCell = tableView.dequeueReusableCell(withIdentifier: Const.Xib.EmptyCardListTableViewCell, for: indexPath) as? EmptyCardListTableViewCell else { return UITableViewCell() }
            
            return serviceCell
        } else {
            guard let serviceCell = tableView.dequeueReusableCell(withIdentifier: Const.Xib.cardListTableViewCell, for: indexPath) as? CardListTableViewCell else { return UITableViewCell() }
            
            serviceCell.initData(title: cardItems[indexPath.row].cardName)
            serviceCell.pinButton.addTarget(self, action: #selector(pinButtonClicked(_:)), for: .touchUpInside)
            
            if indexPath.row == 0 {
                serviceCell.pinButton.imageView?.image = UIImage(named: "iconPin")
                serviceCell.pinButton.isEnabled = false
                serviceCell.reorderButton.isHidden = true
            } else {
                serviceCell.pinButton.imageView?.image = UIImage(named: "iconPinInactive")
                serviceCell.pinButton.isEnabled = true
                serviceCell.reorderButton.isHidden = false
            }
            
            return serviceCell
        }
    }
}

// MARK: - Network
extension CardListViewController {
    func cardListFetchWithAPI() {
        CardAPI.shared.cardListFetch { response in
            switch response {
            case .success(let data):
                if let card = data as? [Card] {
                    self.cardItems = card
                    self.cardListTableView.reloadData()
                }
            case .requestErr(let message):
                print("getCardListFetchWithAPI - requestErr", message)
            case .pathErr:
                print("getCardListFetchWithAPI - pathErr")
            case .serverErr:
                print("getCardListFetchWithAPI - serverErr")
            case .networkFail:
                print("getCardListFetchWithAPI - networkFail")
            }
        }
    }
    
    func cardReorderWithAPI(request: [CardReorderInfo]) {
        CardAPI.shared.cardReorder(request: request) { response in
            switch response {
            case .success(let data):
                print("postCardReorderWithAPI - success: ", data)
            case .requestErr(let message):
                print("postCardReorderWithAPI - requestErr: ", message)
            case .pathErr:
                print("postCardReorderWithAPI - pathErr")
            case .serverErr:
                print("postCardReorderWithAPI - serverErr")
            case .networkFail:
                print("postCardReorderWithAPI - networkFail")
            }
        }
    }
    
    func deleteCardWithAPI(cardID: Int) {
        CardAPI.shared.cardDelete(cardID: cardID) { response in
            switch response {
            case .success(let data):
                print(data)
                self.cardListFetchWithAPI()
                self.cardListTableView.reloadData()
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
    
}

// MARK: - Extension: 테이블 뷰 Drag & Drop 기능
extension CardListViewController {
    @objc func longPressCalled(gestureRecognizer: UIGestureRecognizer) {
        guard let longPress = gestureRecognizer as? UILongPressGestureRecognizer else { return }
        let state = longPress.state
        let locationInView = longPress.location(in: cardListTableView)
        let indexPath = cardListTableView.indexPathForRow(at: locationInView)
        
        // 최초 indexPath 변수
        struct Initial {
            static var initialIndexPath: IndexPath?
            static var tabIndex: IndexPath?
        }
        
        // 스냅샷
        struct MyCell {
            static var cellSnapshot: UIView?
            static var cellIsAnimating: Bool = false
            static var cellNeedToShow: Bool = false
        }
        
        // UIGestureRecognizer 상태에 따른 case 분기처리
        switch state {
            
        // longPress 제스처가 시작할 때 case
        case UIGestureRecognizer.State.began:
            if indexPath!.row != 0 {
                Initial.initialIndexPath = indexPath
                Initial.tabIndex = indexPath
                var cell: UITableViewCell? = UITableViewCell()
                cell = cardListTableView.cellForRow(at: indexPath!)
                
                MyCell.cellSnapshot = snapShotOfCall(cell!)
                
                var center = cell?.center
                MyCell.cellSnapshot!.center = center!
                MyCell.cellSnapshot!.alpha = 0.0
                cardListTableView.addSubview(MyCell.cellSnapshot!)
                
                UIView.animate(withDuration: 0.25, animations: { () -> Void in
                    center?.y = locationInView.y
                    MyCell.cellIsAnimating = true
                    MyCell.cellSnapshot!.center = center!
                    MyCell.cellSnapshot!.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                    MyCell.cellSnapshot!.alpha = 0.98
                    cell?.alpha = 0.0
                }, completion: { (finished) -> Void in
                    if finished {
                        MyCell.cellIsAnimating = false
                        if MyCell.cellNeedToShow {
                            MyCell.cellNeedToShow = false
                            UIView.animate(withDuration: 0.25, animations: { () -> Void in
                                cell?.alpha = 1
                            })
                        } else {
                            cell?.isHidden = true
                        }
                    }
                })
            }
        // longPress 제스처가 변경될 때 case
        case UIGestureRecognizer.State.changed:
            if MyCell.cellSnapshot != nil {
                var center = MyCell.cellSnapshot!.center
                center.y = locationInView.y
                MyCell.cellSnapshot!.center = center
                
                if ((indexPath?.row != 0) && (indexPath != Initial.initialIndexPath)) && (Initial.initialIndexPath != nil) && (indexPath != nil) {
                    // this line change row index
                    self.cardItems.insert(self.cardItems.remove(at: Initial.initialIndexPath!.row), at: indexPath!.row)
                    cardListTableView.moveRow(at: Initial.initialIndexPath!, to: indexPath!)
                    Initial.initialIndexPath = indexPath
                }
            }
        // longPress 제스처가 끝났을 때 case
        default:
            if Initial.initialIndexPath != nil {
                let cell = cardListTableView.cellForRow(at: Initial.initialIndexPath!)
                if MyCell.cellIsAnimating {
                    MyCell.cellNeedToShow = true
                } else {
                    cell?.isHidden = false
                    cell?.alpha = 0.0
                }
                
                UIView.animate(withDuration: 0.2, animations: { () -> Void in
                    MyCell.cellSnapshot!.center = (cell?.center)!
                    MyCell.cellSnapshot!.transform = CGAffineTransform.identity
                    MyCell.cellSnapshot!.alpha = 0.0
                    cell?.alpha = 1.0
                }, completion: { [weak self] (finished) -> Void in
                    if finished {
                        guard let self = self else { return }
                        
                        newCardItems = []
                        
                        for index in 0..<(cardItems.count) {
                            newCardItems.append(CardReorderInfo(cardID: cardItems[index].cardID,
                                                                isRepresentative: index == 0 ? true : false,
                                                                sortOrder: index == 0 ? 0 : cardItems.count - index))
                        }
                        cardReorderWithAPI(request: newCardItems)
                        
                        Initial.initialIndexPath = nil
                        MyCell.cellSnapshot!.removeFromSuperview()
                        MyCell.cellSnapshot = nil
                    }
                })
            }
        }
    }
}
