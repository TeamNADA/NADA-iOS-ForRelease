//
//  MoreViewController.swift
//  NADA-iOS-forRelease
//
//  Created by 민 on 2021/11/18.
//

import UIKit
import KakaoSDKUser

class MoreViewController: UIViewController {
    
    // MARK: - Properteis
    let defaults = UserDefaults.standard
    
    var firstItems = ["개인정보 처리방침", "서비스 이용약관", "Team NADA", "오픈소스 라이브러리"]
    var secondItems = ["로그아웃", "받은 명함 초기화", "모든 명함 삭제하기"]
    
    // MARK: - @IBOutlet Properties
    @IBOutlet weak var moreListTableView: UITableView!
    @IBOutlet weak var darkModeHeaderView: UIView!
    @IBOutlet weak var modeSwitch: UISwitch!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        setModeSwitch()
    }
    
    // MARK: - @IBAction Properties
    @IBAction func darkModeChangeSwitch(_ sender: UISwitch) {
        changeInterfaceStyle()
    }
}

// MARK: - Extensions
extension MoreViewController {
    private func setUI() {
        moreListTableView.register(MoreListTableViewCell.nib(), forCellReuseIdentifier: "MoreListTableViewCell")
        
        moreListTableView.delegate = self
        moreListTableView.dataSource = self
        moreListTableView.tableHeaderView = darkModeHeaderView
    }
    
    private func setModeSwitch() {
        modeSwitch.isOn = defaults.bool(forKey: Const.UserDefaultsKey.darkModeState)
        changeInterfaceStyle()
    }
    
    private func changeInterfaceStyle() {
        if let window = UIApplication.shared.windows.first {
            if #available(iOS 13.0, *) {
                window.overrideUserInterfaceStyle = modeSwitch.isOn == true ? .dark : .light
                defaults.set(modeSwitch.isOn, forKey: Const.UserDefaultsKey.darkModeState)
            } else {
                window.overrideUserInterfaceStyle = .light
            }
        }
    }
}

// MARK: - TableView Delegate
extension MoreViewController: UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0: openURL(link: URL(string: Const.URL.policyURL)!)
            case 1: openURL(link: URL(string: Const.URL.serviceURL)!)
            case 2: pushView(nextSB: Const.Storyboard.Name.teamNADA,
                             nextVC: Const.ViewController.Identifier.teamNADAViewController)
            case 3: pushView(nextSB: Const.Storyboard.Name.openSource,
                             nextVC: Const.ViewController.Identifier.openSourceViewController)
            default: print("default!")
            }
        } else if indexPath.section == 1 {
            switch indexPath.row {
            case 0: setLogoutClicked()
            case 1: setResetClicked()
            case 2: setDeleteCicked()
            default: print("default!")
            }
        }
    }
}

// MARK: - 셀 클릭에 따른 작업 분리
extension MoreViewController {
    
    func openURL(link: URL) {
        if UIApplication.shared.canOpenURL(link) {
            UIApplication.shared.open(link, options: [:], completionHandler: nil)
        }
    }
    
    func pushView(nextSB: String, nextVC: String) {
        let nextVC = UIStoryboard(name: nextSB, bundle: nil).instantiateViewController(identifier: nextVC)
        
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    func setLogoutClicked() {
        makeOKCancelAlert(title: "", message: "로그아웃 하시겠습니까?", okAction: { _ in
            self.makeOKAlert(title: "", message: "로그아웃이 완료 되었습니다.") { _ in
                // TODO: - KeyChain 적용
                if let acToken = UserDefaults.standard.string(forKey: Const.UserDefaultsKey.accessToken) {
//                if let acToken = KeyChain.read(key: Const.KeyChainKey.accessToken) {
                    self.logoutUserWithAPI(token: acToken)
                    // TODO: - KeyChain 적용
                    self.defaults.removeObject(forKey: Const.UserDefaultsKey.accessToken)
                    self.defaults.removeObject(forKey: Const.UserDefaultsKey.refreshToken)
//                    KeyChain.delete(key: Const.KeyChainKey.accessToken)
//                    KeyChain.delete(key: Const.KeyChainKey.refreshToken)
                    self.defaults.removeObject(forKey: Const.UserDefaultsKey.darkModeState)
                    let nextVC = UIStoryboard(name: Const.Storyboard.Name.login, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.loginViewController)
                    nextVC.modalPresentationStyle = .overFullScreen
                    self.navigationController?.changeRootViewController(nextVC)
                }
            }
        })
    }
    
    func setResetClicked() {
        makeOKCancelAlert(title: "", message: "받은 명함과 그룹이 모두 초기화됩니다. 정말 초기화하시겠습니까?", okAction: { _ in
            UserApi.shared.logout { (error) in
                if let error = error {
                    print(error)
                } else {
                    self.makeOKAlert(title: "", message: "받은 명함이 초기화 되었습니다.")
                    // TODO: - KeyChain 적용
                    if let acToken = UserDefaults.standard.string(forKey: Const.UserDefaultsKey.accessToken) {
//                    if let acToken = KeyChain.read(key: Const.KeyChainKey.accessToken) {
//                        self.groupResetWithAPI(token: acToken)
                    }
                }
            }
        })
    }
    
    func setDeleteCicked() {
        makeOKCancelAlert(title: "", message: "내 명함과 받은 명함이 모두 삭제됩니다. 삭제 하시겠습니까?", okAction: { _ in
            UserApi.shared.logout { (error) in
                if let error = error {
                    print(error)
                } else {
                    self.makeOKAlert(title: "", message: "모든 명함이 삭제되었습니다.") { _ in
                        // TODO: - KeyChain 적용
                        if let acToken = UserDefaults.standard.string(forKey: Const.UserDefaultsKey.accessToken) {
//                        if let acToken = KeyChain.read(key: Const.KeyChainKey.accessToken) {
                            self.deleteUserWithAPI(token: acToken)
                            // TODO: - KeyChain 적용
                            self.defaults.removeObject(forKey: Const.UserDefaultsKey.accessToken)
                            self.defaults.removeObject(forKey: Const.UserDefaultsKey.refreshToken)
//                            KeyChain.delete(key: Const.KeyChainKey.accessToken)
//                            KeyChain.delete(key: Const.KeyChainKey.refreshToken)
                            self.defaults.removeObject(forKey: Const.UserDefaultsKey.darkModeState)
                            let nextVC = UIStoryboard(name: Const.Storyboard.Name.login, bundle: nil).instantiateViewController(withIdentifier: Const.ViewController.Identifier.loginViewController)
                            nextVC.modalPresentationStyle = .overFullScreen
                            self.navigationController?.changeRootViewController(nextVC)
                        }
                    }
                }
            }
        })
    }
}

// MARK: - TableView DataSource
extension MoreViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return firstItems.count
        } else if section == 1 {
            return secondItems.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 5
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let serviceCell = tableView.dequeueReusableCell(withIdentifier: Const.Xib.moreListTableViewCell, for: indexPath) as? MoreListTableViewCell else { return UITableViewCell() }
        
        if indexPath.section == 0 {
            serviceCell.titleLabel.text = firstItems[indexPath.row]
            if indexPath.row == firstItems.count - 1 {
                serviceCell.separatorView.isHidden = true
            }
        } else if indexPath.section == 1 {
            serviceCell.titleLabel.text = secondItems[indexPath.row]
        }
        
        return serviceCell
    }
}

// MARK: - Network
extension MoreViewController {
    func deleteUserWithAPI(token: String) {
        UserAPI.shared.userDelete(token: token) { response in
            switch response {
            case .success:
                print("deleteUserWithAPI - success")
            case .requestErr(let message):
                print("deleteUserWithAPI - requestErr: \(message)")
            case .pathErr:
                print("deleteUserWithAPI - pathErr")
            case .serverErr:
                print("deleteUserWithAPI - serverErr")
            case .networkFail:
                print("deleteUserWithAPI - networkFail")
            }
        }
    }
    
    func groupResetWithAPI(token: String) {
        GroupAPI.shared.groupReset(token: token) { response in
            switch response {
            case .success:
                print("groupResetWithAPI - success")
            case .requestErr(let message):
                print("groupResetWithAPI - requestErr: \(message)")
            case .pathErr:
                print("groupResetWithAPI - pathErr")
            case .serverErr:
                print("groupResetWithAPI - serverErr")
            case .networkFail:
                print("groupResetWithAPI - networkFail")
            }
        }
    }
    
    func logoutUserWithAPI(token: String) {
        UserAPI.shared.userLogout(token: token) { response in
            switch response {
            case .success:
                print("logoutUserWithAPI - success")
            case .requestErr(let message):
                print("logoutUserWithAPI - requestErr: \(message)")
            case .pathErr:
                print("logoutUserWithAPI - pathErr")
            case .serverErr:
                print("logoutUserWithAPI - serverErr")
            case .networkFail:
                print("logoutUserWithAPI - networkFail")
            }
        }
    }
    
}
