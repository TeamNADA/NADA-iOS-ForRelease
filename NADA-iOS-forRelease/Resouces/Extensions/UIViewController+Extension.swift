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
    
    func showToast(message: String,
                   font: UIFont,
                   view: String) {
        var toastLabel = UILabel()
        
        switch view {
        case "QRScan":
            toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 85,
                                                   y: self.view.frame.size.height - 230,
                                                   width: 170, height: 35))
        case "copyID":
            toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 110,
                                                   y: self.view.frame.size.height/2,
                                                   width: 230, height: 35))
        case "saveImage":
            toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 85,
                                                   y: self.view.frame.size.height/2,
                                                   width: 170, height: 35))
        default:
            toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 85,
                                                   y: self.view.frame.size.height - 230,
                                                   width: 170, height: 35))
        }
        
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 0.9
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 2.0, delay: 0.1,
                       options: .curveEaseOut, animations: { toastLabel.alpha = 0.0 },
                       completion: {_ in toastLabel.removeFromSuperview() })
    }
}
