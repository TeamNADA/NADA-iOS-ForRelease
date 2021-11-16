//
//  BackCardCreationDelegate.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2021/08/08.
//

import Foundation

protocol BackCardCreationDelegate: AnyObject {
    func backCardCreation(requiredInfo valid: Bool)
    func backCardCreation(withRequired requiredInfo: [String: Bool], withOptional optionalInfo: [String: String] )
}
