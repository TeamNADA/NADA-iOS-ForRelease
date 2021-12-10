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
    let policyURL = URL(string: "https://nadaitzme.notion.site/NADA-8385054bc2e44762a62f590534b2a24d")!
    let serviceURL = URL(string: "https://nadaitzme.notion.site/NADA-58544bc9f0a1493c94f223cab3a440d0")!
    
    var firstItems = ["개인정보 처리방침", "서비스 이용약관", "Team NADA", "오픈소스 라이브러리"]
    var secondItems = ["로그아웃", "정보 초기화", "회원탈퇴"]
    
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
        modeSwitch.isOn = defaults.bool(forKey: Const.UserDefaults.darkModeState)
        changeInterfaceStyle()
    }
    
    private func changeInterfaceStyle() {
        if let window = UIApplication.shared.windows.first {
            if #available(iOS 13.0, *) {
                window.overrideUserInterfaceStyle = modeSwitch.isOn == true ? .dark : .light
                defaults.set(modeSwitch.isOn, forKey: Const.UserDefaults.darkModeState)
            } else {
                window.overrideUserInterfaceStyle = .light
            }
        }
    }
    
    private func logout() {
        // ✅ 로그아웃 : 로그아웃은 API 요청의 성공 여부와 관계없이 토큰을 삭제 처리한다는 점에 유의합니다.
        UserApi.shared.logout {(error) in
            if let error = error {
                print(error)
            }
            else {
                print("logout() success.")
                
                // ✅ 로그아웃 시 메인으로 보냄
                self.navigationController?.popViewController(animated: true)
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
            case 0: openURL(link: policyURL)
            case 1: openURL(link: serviceURL)
            case 2: print("Team NADA")
            case 3: print("오픈소스 라이브러리")
            default: print("default!")
            }
        } else if indexPath.section == 1 {
            switch indexPath.row {
            case 0:
                print("로그아웃!")
                // logout()
            case 1: print("정보 초기화!")
            case 2:
                print("회원탈퇴!")
                // TODO: - 회원탈퇴 서버 전, alert 창이나 별도의 알림 필요, 수정 요함
                deleteUserWithAPI(userID: "2alswo7@naver.com")
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
    func deleteUserWithAPI(userID: String) {
        UserAPI.shared.userDelete(userID: userID) { response in
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
}
