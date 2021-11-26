//
//  UIViewController+Extension.swift
//  NADA-iOS-forRelease
//
//  Created by 민 on 2021/10/02.
//

import Foundation
import UIKit

extension UIViewController {
    
    /// 취소+삭제 UIAlertController
    func makeCancelDeleteAlert(title: String,
                               message: String,
                               cancelAction: ((UIAlertAction) -> Void)? = nil,
                               deleteAction: ((UIAlertAction) -> Void)?,
                               completion: (() -> Void)? = nil) {
        
        let alertViewController = UIAlertController(title: title,
                                                    message: message,
                                                    preferredStyle: .alert)
        
        // FIXME: - 민재선배 아래주석 삭제해도 되나요??
        // alertViewController.setTitle(font: UIFont.boldSystemFont(ofSize: 17), color: UIColor.white)
        // alertViewController.setMessage(font: UIFont.systemFont(ofSize: 13), color: UIColor.white)
        // alertViewController.setTint(color: .mainBlue)
        
        // alertViewController.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 3/4)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: cancelAction)
        alertViewController.addAction(cancelAction)
        
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive, handler: deleteAction)
        alertViewController.addAction(deleteAction)
        
        self.present(alertViewController, animated: true, completion: completion)
    }
    
    /// 확인+취소 UIAlertController
    func makeOKCancelAlert(title: String,
                           message: String,
                           okAction: ((UIAlertAction) -> Void)?,
                           cancelAction: ((UIAlertAction) -> Void)? = nil,
                           completion: (() -> Void)? = nil) {
        let alertViewController = UIAlertController(title: title,
                                                    message: message,
                                                    preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "확인", style: .default, handler: okAction)
        alertViewController.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: cancelAction)
        alertViewController.addAction(cancelAction)
        
        self.present(alertViewController, animated: true, completion: completion)
    }
    
    /// 확인 UIAlertController
    func makeOKAlert(title: String,
                     message: String,
                     okAction: ((UIAlertAction) -> Void)? = nil,
                     completion: (() -> Void)? = nil) {
        let alertViewController = UIAlertController(title: title,
                                                    message: message,
                                                    preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "확인", style: .default, handler: okAction)
        alertViewController.addAction(okAction)
        
        self.present(alertViewController, animated: true, completion: completion)
    }
}
