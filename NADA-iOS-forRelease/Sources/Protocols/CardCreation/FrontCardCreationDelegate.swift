//
//  FrontCardDelegate.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2021/11/09.
//

import Foundation

protocol FrontCardCreationDelegate: AnyObject {
    func frontCardCreation(requiredInfo valid: Bool)
    func frontCardCreation(endEditing valid: Bool)
    func frontCardCreation(withRequired requiredInfo: [String: String], withOptional optionalInfo: [String: String] )
}
