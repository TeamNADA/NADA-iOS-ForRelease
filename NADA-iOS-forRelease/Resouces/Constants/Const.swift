//
//  Const.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2021/08/08.
//

import Foundation

struct Const {
    static let headerToken: String = UserDefaults.standard.string(forKey: Const.UserDefaultsKey.accessToken) ?? ""
}
