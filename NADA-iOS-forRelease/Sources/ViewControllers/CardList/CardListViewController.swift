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
        setLongPressGesture()
        
        cardListTableView.register(CardListTableViewCell.nib(), forCellReuseIdentifier: "CardListTableViewCell")
        
        cardListTableView.delegate = self
        cardListTableView.dataSource = self
        
        // FIXME: - 카드 리스트 조회 서버 테스트
//        cardListFetchWithAPI(userID: "nada", isList: true, offset: 0)
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
    func setCardList() {
        cardItems.append(contentsOf: [
            CardListDataModel(title: "SOPT 28기 명함"),
            CardListDataModel(title: "SOPT 28기 명함"),
            CardListDataModel(title: "SOPT 28기 명함"),
            CardListDataModel(title: "SOPT 28기 명함"),
            CardListDataModel(title: "SOPT 28기 명함"),
            CardListDataModel(title: "SOPT 28기 명함"),
            CardListDataModel(title: "SOPT 28기 명함")
        ])
    }
    
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
}

// MARK: - UITableViewDelegate
extension CardListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 58
    }
    
    // Swipe Action
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "삭제", handler: { (_ action, _ view, _ success) in
            self.makeAlert(title: "명함 삭제", message: "명함을 정말 삭제하시겠습니까?", cancelAction: { _ in
                // 취소 눌렀을 때 액션이 들어갈 부분
            }, deleteAction: { _ in
                // FIXME: - 카드 삭제 서버 테스트
                // self.deleteCardWithAPI(cardID: "cardA")
            }, completion: nil)
        })
        deleteAction.backgroundColor = .red
        
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])
        swipeActions.performsFirstActionWithFullSwipe = false
        
        return swipeActions
    }
}

// MARK: - Network

extension CardListViewController {
    func cardListFetchWithAPI(userID: String, isList: Bool, offset: Int) {
        CardAPI.shared.cardListFetch(userID: userID, isList: isList, offset: offset) { response in
            switch response {
            case .success(let data):
                if let card = data as? CardListRequest {
                    print(card)
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
    
    func cardListEditWithAPI(request: CardListEditRequest) {
        CardAPI.shared.cardListEdit(request: request) { response in
            switch response {
            case .success(let data):
                print(data)
            case .requestErr(let message):
                print("putCardListEditWithAPI - requestErr", message)
            case .pathErr:
                print("putCardListEditWithAPI - pathErr")
            case .serverErr:
                print("putCardListEditWithAPI - serverErr")
            case .networkFail:
                print("putCardListEditWithAPI - networkFail")
            }
        }
    }
    
    func deleteCardWithAPI(cardID: String) {
        CardAPI.shared.cardDelete(cardID: cardID) { response in
            switch response {
            case .success(let data):
                print(data)
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

// MARK: - UITableViewDataSource
extension CardListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cardItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let serviceCell = tableView.dequeueReusableCell(withIdentifier: Const.Xib.cardListTableViewCell, for: indexPath) as? CardListTableViewCell else { return UITableViewCell() }
        
        serviceCell.initData(title: cardItems[indexPath.row].title)
        
        return serviceCell
    }
}

// MARK: - Extension: 테이블 뷰 Drag & Drop 기능
extension CardListViewController {
    // FIX: cyclomatic_complexity 워닝 발생 -> decision이 복잡해서라는데...일단 보류...
    @objc func longPressCalled(gestureRecognizer: UIGestureRecognizer) {
        guard let longPress = gestureRecognizer as? UILongPressGestureRecognizer else { return }
        let state = longPress.state
        let locationInView = longPress.location(in: cardListTableView)
        let indexPath = cardListTableView.indexPathForRow(at: locationInView)
        
        // 최초 indexPath 변수
        struct Initial {
            static var initialIndexPath: IndexPath?
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
            if indexPath != nil {
                Initial.initialIndexPath = indexPath
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
                
                if ((indexPath != nil) && (indexPath != Initial.initialIndexPath)) && Initial.initialIndexPath != nil {
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
                    
                }, completion: { (finished) -> Void in
                    if finished {
                        Initial.initialIndexPath = nil
                        MyCell.cellSnapshot!.removeFromSuperview()
                        MyCell.cellSnapshot = nil
                        
                        // FIXME: - 카드 리스트 조회 서버 테스트
                        // self.putCardListEditWithAPI(request: CardListEditRequest(ordered: [Ordered(cardID: "cardA", priority: 1), Ordered(cardID: "cardB", priority: 0)]))
                    }
                })
            }
        }
    }
}
