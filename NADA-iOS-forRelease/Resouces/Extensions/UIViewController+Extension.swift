//
//  UIViewController+Extension.swift
//  NADA-iOS-forRelease
//
//  Created by 민 on 2021/10/02.
//

import Foundation
import UIKit

extension UIViewController {
    
    // RootStackTabViewController
    var rootVC: RootStackTabViewController? {
        var selfVC = self
        while let parentVC = selfVC.parent {
            if let vc = parentVC as? RootStackTabViewController {
                return vc
            } else {
                selfVC = parentVC
            }
        }
        return nil
    }
    
    // Common Alert
    func makeAlert(title: String,
                   message: String,
                   cancelAction: ((UIAlertAction) -> Void)? = nil,
                   deleteAction: ((UIAlertAction) -> Void)?,
                   completion: (() -> Void)? = nil) {
        
        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alertViewController.setTitle(font: UIFont.boldSystemFont(ofSize: 17), color: UIColor.white)
        alertViewController.setMessage(font: UIFont.systemFont(ofSize: 13), color: UIColor.white)
        alertViewController.setTint(color: .mainBlue)
        
        alertViewController.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 3/4)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: cancelAction)
        alertViewController.addAction(cancelAction)
        
        let deleteAction = UIAlertAction(title: "삭제", style: .default, handler: deleteAction)
        alertViewController.addAction(deleteAction)
        
        self.present(alertViewController, animated: true, completion: completion)
    }
    
}
