//
//  OpenSourceViewController.swift
//  NADA-iOS-forRelease
//
//  Created by 민 on 2021/12/11.
//

import UIKit

class OpenSourceViewController: UIViewController {

    var openSourceList = ["Moya", "SkeletonView", "SwiftLint", "VerticalCardSwiper", "KakaoSDK", "IQKeyboardManagerSwift"]
    
    let moyaURL = URL(string: "https://github.com/Moya/Moya")!
    let skeletonURL = URL(string: "https://github.com/Juanpe/SkeletonView")!
    let swiftLintURL = URL(string: "https://github.com/realm/SwiftLint")!
    let cardSwiperURL = URL(string: "https://github.com/JoniVR/VerticalCardSwiper")!
    let kakaoURL = URL(string: "https://developers.kakao.com/sdk/reference/ios/release/KakaoSDKCommon/index.html")!
    let keyboardURL = URL(string: "https://github.com/hackiftekhar/IQKeyboardManager")!

    @IBOutlet weak var openSourceTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        navigationBackSwipeMotion()
    }
    
    @IBAction func dismissToPreviousView(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

// MARK: - Extensions
extension OpenSourceViewController {
    
    func setUI() {
        openSourceTableView.register(OpenSourceTableViewCell.nib(), forCellReuseIdentifier: Const.Xib.openSourceTableViewCell)
        
        openSourceTableView.delegate = self
        openSourceTableView.dataSource = self
    }
    
    func navigationBackSwipeMotion() {
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    func openURL(link: URL) {
        if UIApplication.shared.canOpenURL(link) {
            UIApplication.shared.open(link, options: [:], completionHandler: nil)
        }
    }
    
}

// MARK: - TableView Delegate
extension OpenSourceViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)
        cell!.contentView.backgroundColor = .background
        
        switch indexPath.row {
        case 0: openURL(link: moyaURL)
        case 1: openURL(link: skeletonURL)
        case 2: openURL(link: swiftLintURL)
        case 3: openURL(link: cardSwiperURL)
        case 4: openURL(link: kakaoURL)
        case 5: openURL(link: keyboardURL)
        default: print("default!")
            
        }
    }
    
}

// MARK: - TableView DataSource
extension OpenSourceViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return openSourceList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let serviceCell = tableView.dequeueReusableCell(withIdentifier: Const.Xib.openSourceTableViewCell, for: indexPath) as? OpenSourceTableViewCell else { return UITableViewCell() }
        
        serviceCell.titleLabel.text = openSourceList[indexPath.row]
        
        return serviceCell
    }
}
