//
//  UIApplication+Extension.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2023/01/24.
//

import UIKit

extension UIApplication {
    public class func mostTopViewController(of base: UIViewController? = nil) -> UIViewController? {
        var baseVC: UIViewController?
        
        if base != nil {
            baseVC = base
        } else {
            baseVC = (UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .first { $0.isKeyWindow })?.rootViewController
        }
        
        if let naviController = baseVC as? UINavigationController {
            return mostTopViewController(of: naviController.visibleViewController)
        } else if let tabbarController = baseVC as? UITabBarController,
                  let selected = tabbarController.selectedViewController {
            return mostTopViewController(of: selected)
        } else if let presented = baseVC?.presentedViewController {
            return mostTopViewController(of: presented)
        }
        
        return baseVC
    }
}
