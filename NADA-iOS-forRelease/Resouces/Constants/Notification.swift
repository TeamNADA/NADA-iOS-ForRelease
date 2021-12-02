//
//  Notification.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2021/10/03.
//

import Foundation

extension Notification.Name {
    static let deleteTabBar = NSNotification.Name("deleteTabBar")
    static let expressTabBar = NSNotification.Name("expressTabBar")
    
    // MARK: - Card Creation
    static let frontCardBirth = Notification.Name("frontCardBirth")
    static let frontCardMBTI = Notification.Name("frontCardMBTI")
    static let presentingImagePicker = Notification.Name("presentingImagePicker")
    static let sendNewImage = Notification.Name("sendNewImage")
}
