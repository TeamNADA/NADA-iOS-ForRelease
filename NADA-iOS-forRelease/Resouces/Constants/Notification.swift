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
    static let passDataToGroup = Notification.Name("passDataToGroup")
    static let passDataToDetail = Notification.Name("passDataToDetail")
    static let reloadGroupViewController = Notification.Name("reloadGroupViewController")
    static let creationReloadMainCardSwiper = Notification.Name("creationReloadMainCardSwiper")
    static let dismissQRCodeCardResult = Notification.Name("dismissQRCodeCardResult")
    static let scrollToSecondIndex = Notification.Name("scrollToSecondIndex")
    static let scrollToFirstIndex = Notification.Name("scrollToFirstIndex")
    static let presentMail = Notification.Name("presentMail")
    static let presentDynamicLink = Notification.Name("presentDynamicLink")
    static let backToHome = Notification.Name("backToHome")
    static let presentToReceivedTagSheet = Notification.Name("presentToTagSheet")
    static let completeSendTag = Notification.Name("completeSendTag")
}
