//
//  TabBarViewController.swift
//  NADA-iOS-forRelease
//
//  Created by 민 on 2021/11/18.
//

import MessageUI
import UIKit

class TabBarViewController: UITabBarController {
    
    // MARK: - Properties
    
    private let borderLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .textBox
        
        return view
    }()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    // MARK: - @Functions
    // UI 세팅 작업
    private func setupUI() {
        tabBar.addSubview(borderLineView)
        
        setupLayout()
        setNotification()
    }
    
    // 레이아웃 세팅
    private func setupLayout() {
        borderLineView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            borderLineView.topAnchor.constraint(equalTo: tabBar.topAnchor),
            borderLineView.leadingAnchor.constraint(equalTo: tabBar.leadingAnchor),
            borderLineView.trailingAnchor.constraint(equalTo: tabBar.trailingAnchor),
            borderLineView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
}

// MARK: - Methods

extension TabBarViewController {
    private func setNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(presentMail), name: .presentMail, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(presentCardDetailVC), name: .presentDynamicLink, object: nil)
    }
    
    private func presentToCardDetailVC(cardDataModel: Card) {
        let cardDetailVC = ModuleFactory.shared.makeCardDetailVC()
        cardDetailVC.status = .add
        cardDetailVC.cardDataModel = cardDataModel
        self.present(cardDetailVC, animated: true)
    }
    
    private func checkDynamicLink(_ dynamicLinkCardUUID: String) {
        self.cardDetailFetchWithAPI(cardUUID: dynamicLinkCardUUID) { [weak self] cardDataModel in
            self?.cardAddInGroupWithAPI(cardUUID: dynamicLinkCardUUID) {
                self?.presentToCardDetailVC(cardDataModel: cardDataModel)
            }
        }
    }
    
    // MARK: - @objc Methods
    
    @objc
    private func presentMail(_ notification: Notification) {
        if MFMailComposeViewController.canSendMail() {
            let mailComposeVC = MFMailComposeViewController()
            mailComposeVC.mailComposeDelegate = self
            
            guard let mailAddress = notification.object as? String else { return }
            mailComposeVC.setToRecipients([mailAddress])
    
            present(mailComposeVC, animated: true, completion: nil)
        } else {
            // 메일이 계정과 연동되지 않은 경우.
            let mailErrorAlert = UIAlertController(title: "메일 전송 실패", message: "이메일 설정을 확인하고 다시 시도해주세요.", preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in }
            mailErrorAlert.addAction(confirmAction)
            present(mailErrorAlert, animated: true, completion: nil)
        }
    }
    
    @objc
    private func presentCardDetailVC(_ notification: Notification) {
        guard let cardUUID = notification.object as? String else { return }
        checkDynamicLink(cardUUID)
    }
}

// MARK: - Network

extension TabBarViewController {
    private func cardDetailFetchWithAPI(cardUUID: String, completion: @escaping (Card) -> Void) {
        CardAPI.shared.cardDetailFetch(cardUUID: cardUUID) { response in
            switch response {
            case .success(let data):
                if let cardDataModel = data as? Card {
                    completion(cardDataModel)
                }
                print("cardDetailFetchWithAPI - success")
            case .requestErr(let message):
                print("cardDetailFetchWithAPI - requestErr", message)
            case .pathErr:
                print("cardDetailFetchWithAPI - pathErr")
            case .serverErr:
                print("cardDetailFetchWithAPI - serverErr")
            case .networkFail:
                print("deleteGroupWithAPI - networkFail")
            }
        }
    }
    private func cardAddInGroupWithAPI(cardUUID: String, completion: @escaping () -> Void) {
        GroupAPI.shared.cardAddInGroup(cardRequest: CardAddInGroupRequest(cardGroupName: "미분류", cardUUID: cardUUID)) { response in
            switch response {
            case .success:
                completion()
                print("cardAddInGroupWithAPI - success")
            case .requestErr(let message):
                print("cardAddInGroupWithAPI - requestErr", message)
            case .pathErr:
                print("cardAddInGroupWithAPI - pathErr")
            case .serverErr:
                print("cardAddInGroupWithAPI - serverErr")
            case .networkFail:
                print("cardAddInGroupWithAPI - networkFail")
            }
        }
    }
}

// MARK: - MFMailComposeViewControllerDelegate

extension TabBarViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .cancelled:
            controller.dismiss(animated: true) { print("mailComposeController - cancelled.")}
        case .saved:
            controller.dismiss(animated: true) { print("mailComposeController - saved.")}
        case .sent:
            controller.dismiss(animated: true) {
                self.showToast(message: "성공적으로 메일을 보냈어요!", font: .button02, view: "default")
            }
        case .failed:
            controller.dismiss(animated: true) { print("mailComposeController - filed.")}
        @unknown default:
            return
        }
    }
}
