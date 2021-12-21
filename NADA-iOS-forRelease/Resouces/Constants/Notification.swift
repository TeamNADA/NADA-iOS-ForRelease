//
//  Notification.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2021/10/03.
//

import Foundation

extension Notification.Name {
    static let completeFrontCardBirth = Notification.Name("completeFrontCardBirth")
    static let completeFrontCardMBTI = Notification.Name("completeFrontCardMBTI")
    static let presentingImagePicker = Notification.Name("presentingImagePicker")
    static let sendNewImage = Notification.Name("sendNewImage")
    static let touchRequiredView = Notification.Name("touchRequiredView")
    static let dismissRequiredBottomSheet = Notification.Name("dismissRequiredBottomSheet")
    static let cancelImagePicker = Notification.Name("cancelImagePicker")
    static let presentCardShare = Notification.Name("presentCardShare")
}
