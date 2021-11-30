//
//  QRScanViewController.swift
//  NADA-iOS-forRelease
//
//  Created by Yi Joon Choi on 2021/11/26.
//

import UIKit

class QRScanViewController: UIViewController {

    // MARK: - Properties
    // 네비게이션 바
    @IBOutlet weak var navigationBarView: UIView!
    @IBOutlet weak var dismissButton: UIButton!
    @IBAction func dismissQRScanViewController(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}

extension QRScanViewController {
    private func registerCell() {

    }
    
    private func setUI() {
        navigationBarView.backgroundColor = .clear
    }
}
