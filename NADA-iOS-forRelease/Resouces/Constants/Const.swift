//
//  Const.swift
//  NADA-iOS-forRelease
//
//  Created by kimhyungyu on 2021/08/08.
//

import Foundation

struct Const {
    // TODO: - KeyChain 적용
    static let headerToken: String = UserDefaults.standard.string(forKey: Const.UserDefaultsKey.accessToken) ?? ""
    //    static var headerToken: String = KeyChain.read(key: Const.KeyChainKey.accessToken) ?? ""
}
